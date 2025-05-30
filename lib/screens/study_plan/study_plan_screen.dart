import 'package:flutter/material.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:
            const Text('Rencana Studi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E90FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing data...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Informasi Akademik
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Terakhir Aktif :',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text('Index Prestasi (IP) : 3.87',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('24251',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('SKS Max',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text('24',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('SKS Tempuh',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text('24',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('SKS Sisa',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text('0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Indikator Persetujuan Dosen Wali
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'TELAH DISETUJUI DOSEN WALI',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Input untuk komentar dosen
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'ok, pertahankan prestasinya',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Mata Kuliah
            _buildCourseListItem(
              context,
              courseCode: 'KFU1503',
              courseName: 'Sistem Terdistribusi',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: true,
            ),
            _buildCourseListItem(
              context,
              courseCode: 'KTU1014',
              courseName: 'Kriptografi',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: true,
            ),
            _buildCourseListItem(
              context,
              courseCode: 'KTU1016',
              courseName: 'Basis Data Terdistribusi',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: true,
            ),
            _buildCourseListItem(
              context,
              courseCode: 'KTU1023',
              courseName: 'Rekayasa Kebutuhan',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: true,
            ),
            _buildCourseListItem(
              context,
              courseCode: 'KTU1026',
              courseName: 'Manajemen Kualitas Perangkat Lunak',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: true,
            ),
            _buildCourseListItem(
              context,
              courseCode: 'KTU1042',
              courseName: 'Augment Reality',
              type: 'Tatap Muka',
              classInfo: 'Kelas : A',
              sks: '3 SKS',
              isApproved: false,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Fitur Tambah Data belum diimplementasikan.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E90FF),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Tambah Data',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showCompleteKRSConfirmation(
                          context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membangun item mata kuliah (tidak ada perubahan)
  Widget _buildCourseListItem(
    BuildContext context, {
    required String courseCode,
    required String courseName,
    required String type,
    required String classInfo,
    required String sks,
    required bool isApproved,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detail Mata Kuliah: $courseName')),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    courseCode,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isApproved)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E90FF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    classInfo,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sks,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan pop-up konfirmasi KRS
  void _showCompleteKRSConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Selesai KRS'),
          content: const Text(
              'Apakah Anda yakin ingin menyelesaikan pengisian KRS?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('KRS berhasil diselesaikan! (Simulasi)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green,
              ),
              child: const Text('Selesaikan',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
