import 'package:flutter/material.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService;

  CourseProvider(this._courseService);

  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  Course? _selectedCourse;
  String? _statusMessage;
  bool _isLoading = false;

  List<Course> get courses => _courses;
  List<Course> get filteredCourses => _filteredCourses;
  Course? get selectedCourse => _selectedCourse;
  String? get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _courseService.getCourses();
      _filteredCourses = List.from(_courses);
      _statusMessage = 'Data mata kuliah berhasil dimuat.';
    } catch (e) {
      _statusMessage = 'Gagal memuat data mata kuliah: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCourses(String searchTerm) {
    if (searchTerm.isEmpty) {
      _filteredCourses = List.from(_courses);
    } else {
      String lowerCaseSearchTerm = searchTerm.toLowerCase();
      _filteredCourses = _courses
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

  Future<void> addSelectedCourseToUser(String userId) async {
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
      _selectedCourse = null;
    } catch (e) {
      _statusMessage = 'Gagal menambahkan mata kuliah: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStatusMessage() {
    _statusMessage = null;
  }
}