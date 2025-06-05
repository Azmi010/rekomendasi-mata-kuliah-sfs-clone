class Course {
  final String code;
  final String name;
  final String type;
  final int sks;
  final int semesterMatkul;
  final String prodiMatkul;
  final String hari;
  final String jamMulai;
  final String jamSelesai;

  Course({
    required this.code,
    required this.name,
    required this.type,
    required this.sks,
    required this.semesterMatkul,
    required this.prodiMatkul,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });

  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      code: data['code'] as String? ?? '',
      name: data['name'] as String? ?? '',
      type: data['type'] as String? ?? '',
      sks: data['sks'] as int? ?? 0,
      semesterMatkul: data['semesterMatkul'] as int? ?? 0,
      prodiMatkul: data['prodiMatkul'] as String? ?? '',
      hari: data['hari'] as String? ?? '',
      jamMulai: data['jamMulai'] as String? ?? '',
      jamSelesai: data['jamSelesai'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'sks': sks,
      'semesterMatkul': semesterMatkul,
      'prodiMatkul': prodiMatkul,
      'hari': hari,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
    };
  }
}