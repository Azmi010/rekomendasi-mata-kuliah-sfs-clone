import 'package:flutter/material.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Transkrip Nilai', style: TextStyle(color: Colors.white)),
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
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informasi Transkrip Nilai')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header Informasi IPK, SKS
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('IPK', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('3.90', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('SKS Total MBKM', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('20', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('SKS', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('113', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Kolom pencarian
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Mata Kuliah',
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Daftar Mata Kuliah (menggunakan Expanded dan SingleChildScrollView)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Algoritma dan Pemrograman',
                    courseCodeSKS: 'KST1102 | 3 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Sistem Basis Data',
                    courseCodeSKS: 'KST1202 | 3 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Teori Graf',
                    courseCodeSKS: 'KST1203 | 2 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Pemrograman Berorientasi Obyek',
                    courseCodeSKS: 'KST1204 | 3 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Interaksi Manusia dan Komputer',
                    courseCodeSKS: 'KST1205 | 3 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Pemrograman SQL',
                    courseCodeSKS: 'KST1306 | 3 SKS',
                    grade: 'A',
                  ),
                  _buildCourseGradeItem(
                    context,
                    courseName: 'Administrasi Sistem',
                    courseCodeSKS: 'KST1308 | 2 SKS',
                    grade: 'A',
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membangun item mata kuliah dan nilai
  Widget _buildCourseGradeItem(
    BuildContext context, {
    required String courseName,
    required String courseCodeSKS,
    required String grade,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detail Nilai: $courseName (Grade: $grade)')),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      courseCodeSKS,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  grade,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}