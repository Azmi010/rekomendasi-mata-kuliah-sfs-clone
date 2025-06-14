import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sfs/models/course.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Management Courses

  // Upload Mata Kuliah
  // Future<void> uploadCourses(List<Course> courses) async {
  //   final CollectionReference coursesCollection = _firestore.collection('courses');
  //   WriteBatch batch = _firestore.batch();

  //   for (var course in courses) {
  //     DocumentReference docRef = coursesCollection.doc(); 
  //     batch.set(docRef, course.toMap());
  //   }

  //   await batch.commit();
  //   print('Courses uploaded successfully with auto-generated IDs!');
  // }

  // Get Mata Kuliah
  Future<List<Course>> getCoursesFromFirestore() async {
    QuerySnapshot snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => Course.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<DocumentSnapshot> fetchUserDocument(String userId) async {
    return _firestore.collection('users').doc(userId).get();
  }
  
  Stream<DocumentSnapshot> fetchKrsStatusDocumentStream(String userId, String krsSemesterKey) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('krs_status')
        .doc(krsSemesterKey)
        .snapshots();
  }

  Future<List<String>> fetchSelectedCourseCodesForSemester(String userId, int semester) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .where('semester', isEqualTo: semester)
        .get();
    
    return snapshot.docs.map((doc) => doc.id).toList(); 
  }

  Stream<QuerySnapshot> fetchSelectedCoursesQuerySnapshotStream(String userId, int userCurrentSemester) {
     return _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .where('semester', isEqualTo: userCurrentSemester)
        .snapshots();
  }
  
  Future<QuerySnapshot> fetchCurrentSemesterCoursesSnapshot(String userId, int currentSemester) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .where('semester', isEqualTo: currentSemester)
        .get();
  }

  Future<DocumentSnapshot> fetchExistingSelectedCourse(String userId, String courseCode) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .doc(courseCode)
        .get();
  }

  Stream<QuerySnapshot> fetchAllSelectedCoursesQuerySnapshotStream(String userId) {
     return _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .orderBy('semester')
        .snapshots();
  }
  
  Future<void> addCourseToUser({
    required String userId,
    required String courseCode,
    required Map<String, dynamic> courseData,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .doc(courseCode)
        .set(courseData);
  }

  Future<void> deleteSelectedCourseFromFirestore(String userId, String courseCode) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('selected_courses')
        .doc(courseCode)
        .delete();
  }

  Future<void> submitKrsToFirestore(String userId, String krsSemesterKey) async {
     await _firestore
        .collection('users')
        .doc(userId)
        .collection('krs_status')
        .doc(krsSemesterKey)
        .set({'submitted': true, 'approved': false, 'advisor_note': ""}, SetOptions(merge: true));
  }

  Future<void> cancelKrsSubmissionInFirestore(String userId, String krsSemesterKey) async {
     await _firestore
        .collection('users')
        .doc(userId)
        .collection('krs_status')
        .doc(krsSemesterKey)
        .set({'submitted': false}, SetOptions(merge: true));
  }
}