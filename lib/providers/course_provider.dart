import 'package:flutter/material.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService;

  CourseProvider(this._courseService);

  List<Course> _masterCourseList = [];
  List<Course> _eligibleCoursesForStudent = [];
  List<Course> _filteredCoursesToDisplay = [];

  Course? _selectedCourse;
  String? _statusMessage;
  bool _isLoading = false;

  List<Course> get filteredCourses => _filteredCoursesToDisplay; 
  
  Course? get selectedCourse => _selectedCourse;
  String? get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchAndFilterCourses(int studentCurrentSemester, String studentProdi) async {
    _isLoading = true;
    notifyListeners();
    try {
      _masterCourseList = await _courseService.getCourses();
      
      List<String> alreadySelectedCourseCodes = await _courseService.getSelectedCourseCodesForCurrentSemester();
      Set<String> selectedCodesSet = alreadySelectedCourseCodes.map((code) => code.trim().toLowerCase()).toSet();

      _eligibleCoursesForStudent = _masterCourseList.where((course) {
        final masterCourseCodeNormalized = course.code.trim().toLowerCase();

        if (selectedCodesSet.contains(masterCourseCodeNormalized)) {
          return false;
        }

        final courseTypeLower = course.type.toLowerCase().trim();
        final studentProdiLower = studentProdi.toLowerCase().trim();
        final courseProdiLower = course.prodiMatkul.toLowerCase().trim();

        if (courseTypeLower == 'pilihan') {
          return true;
        }

        if (courseTypeLower == 'wajib') {
          if (courseProdiLower != studentProdiLower) {
            return false;
          }
          bool isStudentSemesterEven = studentCurrentSemester % 2 == 0;
          if (isStudentSemesterEven) {
            return course.semesterMatkul == 2 || course.semesterMatkul == 4;
          } else {
            return course.semesterMatkul == 1 || course.semesterMatkul == 3 || course.semesterMatkul == 5;
          }
        }
        return false;
      }).toList();

      _filteredCoursesToDisplay = List.from(_eligibleCoursesForStudent);
      _statusMessage = 'Data mata kuliah berhasil dimuat.';

    } catch (e) {
      _statusMessage = 'Gagal memuat data mata kuliah: ${e.toString()}';
      _masterCourseList = [];
      _eligibleCoursesForStudent = [];
      _filteredCoursesToDisplay = [];
      print("ERROR in fetchAndFilterCourses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCourses(String searchTerm) {
    if (searchTerm.isEmpty) {
      _filteredCoursesToDisplay = List.from(_eligibleCoursesForStudent);
    } else {
      String lowerCaseSearchTerm = searchTerm.toLowerCase();
      _filteredCoursesToDisplay = _eligibleCoursesForStudent
          .where((course) =>
              course.code.toLowerCase().contains(lowerCaseSearchTerm) ||
              course.name.toLowerCase().contains(lowerCaseSearchTerm))
          .toList();
    }
    notifyListeners();
  }

  void setSelectedCourse(Course? course) {
    _selectedCourse = course;
    notifyListeners();
  }

  Future<void> addSelectedCourseToUser() async { 
    if (_selectedCourse == null) {
      _statusMessage = 'Pilih mata kuliah terlebih dahulu!';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _statusMessage = 'Menambahkan mata kuliah ke daftar Anda...';
    notifyListeners();
    try {
      await _courseService.addSelectedCourseToUser(course: _selectedCourse!);
      _statusMessage = 'Mata kuliah "${_selectedCourse!.name}" berhasil ditambahkan!';
      final selectedCodeNormalized = _selectedCourse!.code.trim().toLowerCase();
      _eligibleCoursesForStudent.removeWhere((c) => c.code.trim().toLowerCase() == selectedCodeNormalized);
      _filteredCoursesToDisplay.removeWhere((c) => c.code.trim().toLowerCase() == selectedCodeNormalized);
      _selectedCourse = null;
    } catch (e) {
      _statusMessage = 'Gagal menambahkan mata kuliah: ${e.toString().replaceFirst("Exception: ", "")}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStatusMessage() {
    _statusMessage = null;
  }
}