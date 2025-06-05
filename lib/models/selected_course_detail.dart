import 'package:sfs/models/course.dart';

class SelectedCourseDetail extends Course {
  final String grade;
  final int semesterTaken;

  SelectedCourseDetail({
    required super.code,
    required super.name,
    required super.sks,
    required super.type,
    required super.semesterMatkul,
    required super.prodiMatkul,
    required super.hari,
    required super.jamMulai,
    required super.jamSelesai,
    this.grade = "",
    required this.semesterTaken,
  });

  factory SelectedCourseDetail.fromMap(String docId, Map<String, dynamic> data) {
    return SelectedCourseDetail(
      code: docId,
      name: data['name'] as String? ?? 'N/A',
      sks: (data['sks'] is num) ? (data['sks'] as num).toInt() : (int.tryParse(data['sks'].toString()) ?? 0),
      type: data['type'] as String? ?? 'N/A',
      semesterMatkul: data['semesterMatkul'] as int? ?? 0,
      prodiMatkul: data['prodiMatkul'] as String? ?? 'N/A',
      hari: data['hari'] as String? ?? 'N/A',
      jamMulai: data['jamMulai'] as String? ?? 'N/A',
      jamSelesai: data['jamSelesai'] as String? ?? 'N/A',
      grade: data['grade'] as String? ?? '',
      semesterTaken: data['semester'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      'code': code,
      'name': name,
      'sks': sks,
      'type': type,
      'semesterMatkul': semesterMatkul,
      'prodiMatkul': prodiMatkul,
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'grade': grade,
      'semester': semesterTaken,
    };
  }
}