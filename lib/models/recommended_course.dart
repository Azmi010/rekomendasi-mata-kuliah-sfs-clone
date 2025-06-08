class RecommendedCourse {
  final String name;
  final String code;
  final int sks;
  final String prodi;
  final String reason;

  RecommendedCourse({
    required this.name,
    required this.code,
    required this.sks,
    required this.prodi,
    required this.reason,
  });

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) {
    return RecommendedCourse(
      name: json['nama_mk'] ?? 'Nama Tidak Tersedia',
      code: json['kode_mk'] ?? 'Kode Tidak Tersedia',
      sks: json['sks'] ?? 0,
      prodi: json['prodi_penawar'] ?? 'Prodi Tidak Tersedia',
      reason: json['alasan'] ?? 'Tidak ada alasan khusus.',
    );
  }
}