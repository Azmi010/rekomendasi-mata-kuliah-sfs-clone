import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/models/krs_semester_status.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/services/course_service.dart';

class StudyPlanProvider extends ChangeNotifier {
  final CourseService _courseService;

  UserData? _userData;
  List<SelectedCourseDetail> _selectedCourses = [];
  KrsSemesterStatus _krsStatus = KrsSemesterStatus();
  
  bool _isLoading = true;
  String? _statusMessage;
  int _totalSksTaken = 0;

  StreamSubscription? _coursesSubscription;
  StreamSubscription? _krsStatusSubscription;

  UserData? get userData => _userData;
  List<SelectedCourseDetail> get selectedCourses => _selectedCourses;
  KrsSemesterStatus get krsStatus => _krsStatus;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;
  int get totalSksTaken => _totalSksTaken;

  StudyPlanProvider(this._courseService) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userData = await _courseService.getUserProfile();
      if (_userData != null) {
        _listenToCourses(_userData!.currentSemester);
        _listenToKrsStatus(_userData!.currentSemester);
      } else {
        _statusMessage = "Data pengguna tidak ditemukan.";
      }
    } catch (e) {
      _statusMessage = "Gagal memuat data awal: ${e.toString()}";
      _userData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _listenToCourses(int semester) {
    _coursesSubscription?.cancel();
    _coursesSubscription = _courseService.getSelectedCoursesStream(semester).listen(
      (courses) {
        _selectedCourses = courses;
        _calculateTotalSks();
        notifyListeners();
      },
      onError: (error) {
        _statusMessage = "Error data mata kuliah: $error";
        _selectedCourses = [];
        _calculateTotalSks();
        notifyListeners();
      },
    );
  }

  void _listenToKrsStatus(int semester) {
    _krsStatusSubscription?.cancel();
    _krsStatusSubscription = _courseService.getKrsStatusStream(semester).listen(
      (status) {
        _krsStatus = status;
        notifyListeners();
      },
      onError: (error) {
        _statusMessage = "Error data KRS: $error";
        _krsStatus = KrsSemesterStatus();
        notifyListeners();
      },
    );
  }

  void _calculateTotalSks() {
    _totalSksTaken = _selectedCourses.fold(0, (sum, course) => sum + course.sks);
  }

  Future<void> refreshData() async {
    await loadInitialData();
    _statusMessage = _userData != null ? "Data berhasil diperbarui." : _statusMessage;
    notifyListeners();
  }

  Future<void> deleteCourse(String courseDocId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _courseService.deleteSelectedCourse(courseDocId);
      _statusMessage = "Mata kuliah berhasil dihapus.";
    } catch (e) {
      _statusMessage = "Gagal menghapus: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitKrs() async {
    if (_userData == null) {
      _statusMessage = "Data pengguna tidak valid.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      await _courseService.submitKrs(_userData!.currentSemester);
      _statusMessage = "KRS berhasil diselesaikan.";
    } catch (e) {
      _statusMessage = "Gagal: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelKrsSubmission() async {
    if (_userData == null) {
      _statusMessage = "Data pengguna tidak valid.";
      notifyListeners();
      return;
    }
    if (!_krsStatus.isSubmitted || _krsStatus.isApproved) {
        _statusMessage = "KRS tidak dalam kondisi untuk dibatalkan.";
        notifyListeners();
        return;
    }

    _isLoading = true;
    _statusMessage = "Membatalkan pengiriman KRS...";
    notifyListeners();
    try {
      await _courseService.cancelKrsSubmission(_userData!.currentSemester);
      _statusMessage = "Pengiriman KRS berhasil dibatalkan.";
    } catch (e) {
      _statusMessage = "Gagal membatalkan KRS: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearStatusMessage() {
    _statusMessage = null;
  }

  @override
  void dispose() {
    _coursesSubscription?.cancel();
    _krsStatusSubscription?.cancel();
    super.dispose();
  }
}