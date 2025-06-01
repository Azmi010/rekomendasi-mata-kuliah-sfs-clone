import 'package:sfs/models/course.dart';
import 'package:sfs/repositories/course_repository.dart';

class CourseService {
  final CourseRepository _courseRepository;

  CourseService(this._courseRepository);

  List<Course> _cachedCourses = [];

  Future<List<Course>> getCourses() async {
    if (_cachedCourses.isEmpty) {
      _cachedCourses = await _courseRepository.getCoursesFromFirestore();
    }
    return List.from(_cachedCourses);
  }

  Future<List<Course>> searchCourses(String searchTerm) async {
    List<Course> coursesToSearch = await getCourses();
    
    if (searchTerm.isEmpty) {
      return List.from(coursesToSearch);
    }
    String lowerCaseSearchTerm = searchTerm.toLowerCase();
    return coursesToSearch
        .where((course) =>
            course.code.toLowerCase().contains(lowerCaseSearchTerm) ||
            course.name.toLowerCase().contains(lowerCaseSearchTerm))
        .toList();
  }
}