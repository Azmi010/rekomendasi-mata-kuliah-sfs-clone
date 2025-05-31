import 'package:sfs/models/course.dart';

class CourseService {
  // Data dummy mata kuliah
  final List<Course> _allCourses = [
    Course(code: 'KFU1503', name: 'Sistem Terdistribusi', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KTU1014', name: 'Kriptografi', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KTU1016', name: 'Basis Data Terdistribusi', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KTU1023', name: 'Rekayasa Kebutuhan', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KTU1026', name: 'Manajemen Kualitas Perangkat Lunak', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KTU1042', name: 'Augment Reality', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1101', name: 'Praktikum Algoritma dan Pemrograman 1', sks: '2 SKS', type: 'Praktikum'),
    Course(code: 'KST1102', name: 'Algoritma dan Pemrograman 1', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1201', name: 'Struktur Data', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1202', name: 'Sistem Basis Data', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1203', name: 'Teori Graf', sks: '2 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1204', name: 'Pemrograman Berorientasi Objek', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1205', name: 'Interaksi Manusia dan Komputer', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1306', name: 'Pemrograman SQL', sks: '3 SKS', type: 'Tatap Muka'),
    Course(code: 'KST1308', name: 'Administrasi Sistem', sks: '2 SKS', type: 'Tatap Muka'),
  ];

  Future<List<Course>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_allCourses);
  }

  Future<List<Course>> searchCourses(String searchTerm) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (searchTerm.isEmpty) {
      return List.from(_allCourses);
    }
    String lowerCaseSearchTerm = searchTerm.toLowerCase();
    return _allCourses
        .where((course) =>
            course.code.toLowerCase().contains(lowerCaseSearchTerm) ||
            course.name.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();
  }
}