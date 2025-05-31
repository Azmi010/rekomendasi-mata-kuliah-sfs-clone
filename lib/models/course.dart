class Course {
  final String code;
  final String name;
  final String sks;
  final String type;

  Course({
    required this.code,
    required this.name,
    required this.sks,
    required this.type,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      name: json['name'] as String,
      sks: json['sks'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'sks': sks,
      'type': type,
    };
  }
}