import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/models/krs_semester_status.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/repositories/course_repository.dart';

class CourseService {
  final CourseRepository _courseRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CourseService(this._courseRepository);

  List<Course> _cachedCourses = [];
  String? get _userId => _auth.currentUser?.uid;

  Future<List<Course>> getCourses() async {
    if (_cachedCourses.isEmpty) {
      _cachedCourses = await _courseRepository.getCoursesFromFirestore();
    }
    return List.from(_cachedCourses);
  }

  Future<List<Course>> searchCourses(String searchTerm) async {
    List<Course> coursesToSearch = await getCourses();
    
    if (searchTerm.isEmpty) {
      return List.from(coursesToSearch);
    }
    String lowerCaseSearchTerm = searchTerm.toLowerCase();
    return coursesToSearch
        .where((course) =>
            course.code.toLowerCase().contains(lowerCaseSearchTerm) ||
            course.name.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();
  }

  Future<UserData> _fetchUserDataModel() async {
    if (_userId == null) throw Exception("Pengguna belum login.");
    DocumentSnapshot userDoc = await _courseRepository.fetchUserDocument(_userId!);
    if (!userDoc.exists) throw Exception('Data pengguna tidak ditemukan.');
    return UserData.fromMap(_userId!, userDoc.data() as Map<String, dynamic>);
  }

  Future<void> addSelectedCourseToUser({required Course course}) async {
    if (_userId == null) throw Exception('Pengguna belum login.');

    try {
      final userData = await _fetchUserDataModel();
      final int currentSemester = userData.currentSemester;

      final krsStatusDocId = 'semester_$currentSemester';
      final krsStatusDoc = await _courseRepository.fetchKrsStatusDocumentStream(_userId!, krsStatusDocId).first; // Ambil data sekali

      if (krsStatusDoc.exists) {
        final krsStatusData = KrsSemesterStatus.fromMap(krsStatusDoc.data() as Map<String, dynamic>?);
        if (krsStatusData.isSubmitted || krsStatusData.isApproved) {
          throw Exception('KRS semester ini sudah ${krsStatusData.isApproved ? "disetujui" : "dikirim"}.');
        }
      }
      
      final currentSemesterCoursesSnapshot = await _courseRepository.fetchCurrentSemesterCoursesSnapshot(_userId!, currentSemester);
      int currentSksTaken = currentSemesterCoursesSnapshot.docs.fold(0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        int sksValue = (data['sks'] is String)
            ? (int.tryParse(data['sks'] ?? '0') ?? 0)
            : ((data['sks'] is int) ? data['sks'] as int : (data['sks'] is num ? (data['sks'] as num).toInt() : 0));
        return sum + sksValue;
      });
      
      if (currentSksTaken + course.sks > 24) {
        throw Exception('Gagal. Total SKS akan melebihi 24 (Saat ini: $currentSksTaken SKS).');
      }

      final existingCourseDoc = await _courseRepository.fetchExistingSelectedCourse(_userId!, course.code);
      if (existingCourseDoc.exists) {
        throw Exception('Mata kuliah "${course.name}" (${course.code}) sudah ada dalam KRS Anda.');
      }

      final courseDataToSave = {
        'code': course.code,
        'name': course.name,
        'sks': course.sks,
        'type': course.type,
        'grade': '', 
        'semester': currentSemester,
      };

      await _courseRepository.addCourseToUser(
        userId: _userId!,
        courseCode: course.code,
        courseData: courseDataToSave,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserData> getUserProfile() async {
    return await _fetchUserDataModel();
  }

  Stream<List<SelectedCourseDetail>> getSelectedCoursesStream(int userCurrentSemester) {
    if (_userId == null) return Stream.value([]);
    return _courseRepository.fetchSelectedCoursesQuerySnapshotStream(_userId!, userCurrentSemester)
        .map((snapshot) => snapshot.docs
            .map((doc) => SelectedCourseDetail.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<SelectedCourseDetail>> getAllSelectedCoursesStream() {
    if (_userId == null) return Stream.value([]);
    return _courseRepository.fetchAllSelectedCoursesQuerySnapshotStream(_userId!)
        .map((snapshot) => snapshot.docs
            .map((doc) => SelectedCourseDetail.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
  
  Stream<KrsSemesterStatus> getKrsStatusStream(int userCurrentSemester) {
    if (_userId == null) return Stream.value(KrsSemesterStatus());
    final String krsSemesterKey = 'semester_$userCurrentSemester';
    return _courseRepository.fetchKrsStatusDocumentStream(_userId!, krsSemesterKey)
        .map((snapshot) {
          if (snapshot.exists) {
            return KrsSemesterStatus.fromMap(snapshot.data() as Map<String, dynamic>?);
          }
          return KrsSemesterStatus(); 
        });
  }

  Future<void> deleteSelectedCourse(String courseCode) async {
    if (_userId == null) throw Exception("Pengguna belum login.");
    
    final userData = await _fetchUserDataModel();
    final krsStatusDocId = 'semester_${userData.currentSemester}';
    final krsStatusDoc = await _courseRepository.fetchKrsStatusDocumentStream(_userId!, krsStatusDocId).first;

    if (krsStatusDoc.exists) {
      final krsStatusData = KrsSemesterStatus.fromMap(krsStatusDoc.data() as Map<String, dynamic>?);
      if (krsStatusData.isSubmitted || krsStatusData.isApproved) {
        throw Exception('KRS semester ini sudah ${krsStatusData.isApproved ? "disetujui" : "dikirim"}.');
      }
    }

    try {
      await _courseRepository.deleteSelectedCourseFromFirestore(_userId!, courseCode);
    } catch (e) {
      throw Exception('Gagal menghapus mata kuliah: ${e.toString()}');
    }
  }

  Future<void> submitKrs(int userCurrentSemester) async {
    if (_userId == null) throw Exception("Pengguna belum login.");
    
    final selectedCoursesSnapshot = await _courseRepository.fetchCurrentSemesterCoursesSnapshot(_userId!, userCurrentSemester);
    if (selectedCoursesSnapshot.docs.isEmpty) {
      throw Exception('Tidak ada mata kuliah yang dipilih. KRS tidak dapat diselesaikan.');
    }

    final String krsSemesterKey = 'semester_$userCurrentSemester';
    try {
      await _courseRepository.submitKrsToFirestore(_userId!, krsSemesterKey);
    } catch (e) {
      throw Exception('Gagal menyelesaikan KRS: ${e.toString()}');
    }
  }

  Future<void> cancelKrsSubmission(int userCurrentSemester) async {
    if (_userId == null) throw Exception("Pengguna belum login.");
    
    final String krsSemesterKey = 'semester_$userCurrentSemester';
    try {
      final krsStatusDoc = await _courseRepository.fetchKrsStatusDocumentStream(_userId!, krsSemesterKey).first;
      if (krsStatusDoc.exists) {
        final krsStatusData = KrsSemesterStatus.fromMap(krsStatusDoc.data() as Map<String, dynamic>?);
        if (!krsStatusData.isSubmitted) {
          throw Exception('KRS belum dikirim, tidak dapat dibatalkan.');
        }
        if (krsStatusData.isApproved) {
          throw Exception('KRS sudah disetujui, tidak dapat dibatalkan.');
        }
      } else {
         throw Exception('Status KRS tidak ditemukan, tidak dapat dibatalkan.');
      }

      await _courseRepository.cancelKrsSubmissionInFirestore(_userId!, krsSemesterKey);
    } catch (e) {
      rethrow;
    }
  }
}