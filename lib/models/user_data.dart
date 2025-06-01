class UserData {
  final String uid;
  final String name;
  final String nim;
  final String prodi;
  final int currentSemester;

  UserData({
    required this.uid,
    required this.name,
    required this.nim,
    required this.prodi,
    required this.currentSemester,
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
}