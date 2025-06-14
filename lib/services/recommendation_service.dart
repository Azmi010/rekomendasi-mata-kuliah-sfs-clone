import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sfs/models/recommended_course.dart';

class RecommendationService {
  static const String _baseUrl = 'https://model-rekomendasi-matpil.vercel.app/rekomendasi';

  Future<List<RecommendedCourse>> fetchRecommendations({
    required String nim,
    required String prodi,
    required double ipk,
    required int targetSemester,
    required List<Map<String, dynamic>> history,
  }) async {
    final url = Uri.parse(_baseUrl);

    final requestBody = json.encode({
      "nim": nim,
      "prodi": prodi,
      "ipk": ipk,
      "target_semester": targetSemester,
      "riwayat": history,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> recommendationsJson = data['rekomendasi'];
        
        return recommendationsJson
            .map((json) => RecommendedCourse.fromJson(json))
            .toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Gagal memuat rekomendasi dari server: ${errorData['detail'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghubungi layanan rekomendasi: ${e.toString()}');
    }
  }
}