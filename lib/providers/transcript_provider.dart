import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/services/course_service.dart';

class TranscriptProvider extends ChangeNotifier {
  final CourseService _courseService;

  UserData? _userData;
  List<SelectedCourseDetail> _allGradedCourses = [];
  List<SelectedCourseDetail> _filteredGradedCourses = [];
  
  double _gpa = 0.0;
  int _totalSksEarned = 0;

  bool _isLoading = true;
  String? _statusMessage;
  String _searchTerm = '';

  StreamSubscription? _coursesSubscription;

  UserData? get userData => _userData;
  List<SelectedCourseDetail> get filteredCourses => _filteredGradedCourses;
  double get gpa => _gpa;
  int get totalSksEarned => _totalSksEarned;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;

  TranscriptProvider(this._courseService) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userData = await _courseService.getUserProfile(); 

      _coursesSubscription?.cancel();
      _coursesSubscription = _courseService.getAllSelectedCoursesStream().listen(
        (courses) {
          _allGradedCourses = courses.where((course) {
            final grade = course.grade.trim().toUpperCase();
            return grade.isNotEmpty && grade != '-' && grade != 'T' && grade != 'K';
          }).toList();
          
          _calculateTranscriptMetrics();
          _filterCourses(); 
          _isLoading = false; 
          notifyListeners();
        },
        onError: (error) {
          _statusMessage = "Error memuat data mata kuliah: $error";
          _allGradedCourses = [];
          _filteredGradedCourses = [];
          _calculateTranscriptMetrics(); 
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _statusMessage = "Gagal memuat data awal: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateTranscriptMetrics() {
    if (_allGradedCourses.isEmpty) {
      _gpa = 0.0;
      _totalSksEarned = 0;
      notifyListeners();
      return;
    }

    double totalWeightedScore = 0;
    int sksForGpaCalculation = 0;

    for (var course in _allGradedCourses) {
      double gradePoint = _getGradePoint(course.grade);
      if (gradePoint >= 0) { 
          totalWeightedScore += gradePoint * course.sks;
          sksForGpaCalculation += course.sks;
      }
    }
    
    _totalSksEarned = _allGradedCourses.fold(0, (sum, course) => sum + course.sks);
    _gpa = (sksForGpaCalculation > 0) ? (totalWeightedScore / sksForGpaCalculation) : 0.0;
    notifyListeners();
  }

  double _getGradePoint(String grade) {
    switch (grade.trim().toUpperCase()) {
      case 'A': return 4.0;
      case 'AB': return 3.5;
      case 'B': return 3.0;
      case 'BC': return 2.5;
      case 'C': return 2.0;
      case 'CD': return 1.5;
      case 'D': return 1.0;
      case 'E': return 0.0;
      default: return -1.0;
    }
  }

  void searchCourses(String searchTerm) {
    _searchTerm = searchTerm.toLowerCase();
    _filterCourses();
  }

  void _filterCourses() {
    if (_searchTerm.isEmpty) {
      _filteredGradedCourses = List.from(_allGradedCourses);
    } else {
      _filteredGradedCourses = _allGradedCourses.where((course) {
        return course.name.toLowerCase().contains(_searchTerm) ||
               course.code.toLowerCase().contains(_searchTerm);
      }).toList();
    }
    notifyListeners();
  }
  
  Future<void> refreshData() async {
    await _loadInitialData();
  }

  void clearStatusMessage() {
    _statusMessage = null;
  }

  @override
  void dispose() {
    _coursesSubscription?.cancel();
    super.dispose();
  }
}