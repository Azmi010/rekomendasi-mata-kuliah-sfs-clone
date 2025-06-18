class RecommendedCourse {
  final String name;
  final String code;
  final int sks;
  final String prodi;
  final String reason;
  final List<String> careerPaths;

  RecommendedCourse({
    required this.name,
    required this.code,
    required this.sks,
    required this.prodi,
    required this.reason,
    required this.careerPaths,
  });

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) {
    final careersFromJson = json['relevansi_karier'] as List<dynamic>?;
    final careerList = careersFromJson?.map((item) => item.toString()).toList() ?? [];

    return RecommendedCourse(
      name: json['nama_mk'] ?? 'Nama Tidak Tersedia',
      code: json['kode_mk'] ?? 'Kode Tidak Tersedia',
      sks: json['sks'] ?? 0,
      prodi: json['prodi_penawar'] ?? 'Prodi Tidak Tersedia',
      reason: json['alasan'] ?? 'Tidak ada alasan khusus.',
      careerPaths: careerList,
    );
  }
}