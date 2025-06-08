import 'package:sfs/models/selected_course_detail.dart';

class UserData {
  final String uid;
  final String name;
  final String nim;
  final String prodi;
  final int currentSemester;
  final List<SelectedCourseDetail> courses;

  UserData({
    required this.uid,
    required this.name,
    required this.nim,
    required this.prodi,
    required this.currentSemester,
    this.courses = const [],
  });

  factory UserData.fromMap(String uid, Map<String, dynamic> data) {
    return UserData(
      uid: uid,
      name: data['name'] ?? 'N/A',
      nim: data['nim'] ?? 'N/A',
      prodi: data['prodi'] ?? 'N/A',
      currentSemester: data['semester'] as int? ?? 1,
    );
  }

  UserData copyWith({
    List<SelectedCourseDetail>? courses,
  }) {
    return UserData(
      uid: uid,
      name: name,
      nim: nim,
      prodi: prodi,
      currentSemester: currentSemester,
      courses: courses ?? this.courses,
    );
  }
}