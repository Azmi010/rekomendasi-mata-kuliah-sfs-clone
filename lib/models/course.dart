class Course {
  final String code;
  final String name;
  final String type;
  final String sks;

  Course({
    required this.code,
    required this.name,
    required this.type,
    required this.sks,
  });

  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      code: data['code'] as String,
      name: data['name'] as String,
      type: data['type'] as String,
      sks: data['sks'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'type': type, 
      'sks': sks,
    };
  }
}

class RelevantCourse {
  final String mainCourseName;
  final String mainCourseCode;
  final String relevantCourseName;
  final String relevantCourseCode;

  RelevantCourse({
    required this.mainCourseName,
    required this.mainCourseCode,
    required this.relevantCourseName,
    required this.relevantCourseCode,
  });

  factory RelevantCourse.fromMap(Map<String, dynamic> data) {
    return RelevantCourse(
      mainCourseName: data['mainCourseName'] as String,
      mainCourseCode: data['mainCourseCode'] as String,
      relevantCourseName: data['relevantCourseName'] as String,
      relevantCourseCode: data['relevantCourseCode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mainCourseName': mainCourseName,
      'mainCourseCode': mainCourseCode,
      'relevantCourseName': relevantCourseName,
      'relevantCourseCode': relevantCourseCode,
    };
  }
}