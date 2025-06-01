import 'package:sfs/models/course.dart';

class SelectedCourseDetail extends Course {
  final String grade;
  final int semesterTaken;

  SelectedCourseDetail({
    required super.code,
    required super.name,
    required super.sks,
    required super.type,
    this.grade = "",
    required this.semesterTaken,
  });

  factory SelectedCourseDetail.fromMap(String id, Map<String, dynamic> data) {
    return SelectedCourseDetail(
      code: data['code'] ?? 'N/A',
      name: data['name'] ?? 'N/A',
      sks: (data['sks'] is String) ? (int.tryParse(data['sks'] ?? '0') ?? 0) : (data['sks'] ?? 0),
      type: data['type'] ?? 'N/A',
      grade: data['grade'] ?? '',
      semesterTaken: data['semester'] as int? ?? 0,
    );
  }

   Map<String, dynamic> toMapForFirestore() {
    return {
      'code': code,
      'name': name,
      'sks': sks,
      'type': type,
      'grade': grade,
      'semester': semesterTaken,
    };
  }
}