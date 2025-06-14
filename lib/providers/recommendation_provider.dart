import 'package:flutter/material.dart';
import 'package:sfs/models/recommended_course.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/providers/auth_provider.dart';
import 'package:sfs/services/recommendation_service.dart';

class RecommendationProvider with ChangeNotifier {
  final AuthProvider? _authProvider;
  final RecommendationService _recommendationService = RecommendationService();

  List<RecommendedCourse> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  RecommendationProvider(this._authProvider);

  List<RecommendedCourse> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double _calculateIPK(List<SelectedCourseDetail> courses) {
    if (courses.isEmpty) return 0.0;

    double totalBobot = 0;
    int totalSks = 0;

    final Map<String, double> gradePoints = {
      'A': 4.0, 'AB': 3.5, 'B': 3.0, 'BC': 2.5,
      'C': 2.0, 'D': 1.0, 'E': 0.0,
    };
    
    for (var course in courses) {
      if (course.grade.isNotEmpty && course.sks > 0) {
        double point = gradePoints[course.grade.toUpperCase()] ?? 0.0;
        totalBobot += (point * course.sks);
        totalSks += course.sks;
      }
    }

    if (totalSks == 0) return 0.0;
    return totalBobot / totalSks;
  }


  Future<void> getRecommendations() async {
    if (_authProvider?.userData == null) {
      _errorMessage = 'Data pengguna tidak tersedia.';
      notifyListeners();
      return;
    }
    
    final userData = _authProvider!.userData!;
    if (userData.courses.isEmpty) {
      _errorMessage = "Maaf, Anda belum memiliki riwayat mata kuliah untuk mendapatkan rekomendasi";
      notifyListeners();
      return;
    }
    final bool allGradesAreEmpty = userData.courses.every((course) => course.grade.isEmpty);

    if (allGradesAreEmpty) {
      _errorMessage = "Maaf, Anda belum memiliki riwayat mata kuliah untuk mendapatkan rekomendasi";
      notifyListeners();
      return; 
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final double ipk = _calculateIPK(userData.courses);
      
      final history = userData.courses
          .where((course) => course.grade.isNotEmpty)
          .map((course) => {
            'kode': course.code,
            'nilai': course.grade,
            'semester': course.semesterTaken,
          }).toList();

      if (history.isEmpty) {
          throw Exception("Tidak ada riwayat nilai yang valid untuk diproses.");
      }

      _recommendations = await _recommendationService.fetchRecommendations(
        nim: userData.nim,
        prodi: userData.prodi,
        ipk: ipk,
        targetSemester: userData.currentSemester + 1,
        history: history,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}