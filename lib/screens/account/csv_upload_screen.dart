// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:csv/csv.dart';
// import 'dart:convert';
// import 'package:provider/provider.dart';
// import 'package:sfs/models/course.dart';
// import 'package:sfs/repositories/course_repository.dart';

// class CsvUploadScreen extends StatefulWidget {
//   const CsvUploadScreen({super.key});

//   @override
//   State<CsvUploadScreen> createState() => _CsvUploadScreenState();
// }

// class _CsvUploadScreenState extends State<CsvUploadScreen> {
//   String? _statusMessage;
//   bool _isLoading = false;

//   Future<void> _uploadCoursesCsv() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );

//     if (result == null || result.files.single.bytes == null) {
//       _setStatus('Pencarian file dibatalkan atau file kosong.', isError: true);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Mengurai dan mengunggah data mata kuliah...';
//     });

//     try {
//       final bytes = result.files.single.bytes!;
//       final csvString = const Utf8Decoder(allowMalformed: true).convert(bytes);
//       List<List<dynamic>> rowsAsListOfList = const CsvToListConverter(
//         eol: '\n',
//       ).convert(csvString);

//       if (rowsAsListOfList.length < 2) {
//         _setStatus('File CSV mata kuliah kosong atau hanya berisi header.', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }

//       final headers = rowsAsListOfList[0].map((header) => header.toString().trim().toLowerCase()).toList();
//       final dataRows = rowsAsListOfList.sublist(1);

//       print('Detected CSV Headers: $headers');

//       final codeIndex = headers.indexOf('kode_matkul');
//       final nameIndex = headers.indexOf('nama_matkul');
//       final typeIndex = headers.indexOf('sifat_mk');
//       final sksIndex = headers.indexOf('sks_matkul');
//       final semesterMatkulIndex = headers.indexOf('semester_matkul');
//       final prodiMatkulIndex = headers.indexOf('prodi_matkul');
//       final hariIndex = headers.indexOf('hari');
//       final jamMulaiIndex = headers.indexOf('jam_mulai');
//       final jamSelesaiIndex = headers.indexOf('jam_selesai');

//       Map<String, int> headerMap = {
//         'kode_matkul': codeIndex, 'nama_matkul': nameIndex, 'sifat_mk': typeIndex,
//         'sks_matkul': sksIndex, 'semester_matkul': semesterMatkulIndex, 
//         'prodi_matkul': prodiMatkulIndex, 'hari': hariIndex,
//         'jam_mulai': jamMulaiIndex, 'jam_selesai': jamSelesaiIndex,
//       };

//       List<String> missingHeaders = [];
//       headerMap.forEach((key, value) {
//         if (value == -1) {
//           missingHeaders.add(key);
//         }
//       });

//       if (missingHeaders.isNotEmpty) {
//         _setStatus('Header CSV mata kuliah tidak valid. Header berikut tidak ditemukan: ${missingHeaders.join(", ")}.', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }

//       List<Course> courses = [];
//       int rowIndex = 1;
//       for (var row in dataRows) {
//         rowIndex++;
//         try {
//           if (row.length < headers.length) {
//              print('Skipping malformed row $rowIndex (too few columns): $row');
//              continue;
//           }

//           final sksValue = int.tryParse(row[sksIndex].toString().trim());
//           final semesterValue = int.tryParse(row[semesterMatkulIndex].toString().trim());

//           if (sksValue == null) {
//             print('Skipping row $rowIndex due to invalid SKS: ${row[sksIndex]}');
//             continue;
//           }
//           if (semesterValue == null) {
//             print('Skipping row $rowIndex due to invalid Semester: ${row[semesterMatkulIndex]}');
//             continue;
//           }
          
//           courses.add(Course(
//             code: row[codeIndex].toString().trim(),
//             name: row[nameIndex].toString().trim(),
//             type: row[typeIndex].toString().trim(),
//             sks: sksValue,
//             semesterMatkul: semesterValue,
//             prodiMatkul: row[prodiMatkulIndex].toString().trim(),
//             hari: row[hariIndex].toString().trim(),
//             jamMulai: row[jamMulaiIndex].toString().trim(),
//             jamSelesai: row[jamSelesaiIndex].toString().trim(),
//           ));
//         } catch (e) {
//           print('Error parsing row $rowIndex: $row. Error: $e');
//         }
//       }

//       if (courses.isEmpty && dataRows.isNotEmpty) {
//         _setStatus('Tidak ada data mata kuliah valid yang bisa diproses dari file CSV.', isError: true);
//       } else if (courses.isEmpty && dataRows.isEmpty) {
//          _setStatus('Tidak ada baris data mata kuliah di file CSV.', isError: true);
//       }
//       else {
//         final courseRepository = Provider.of<CourseRepository>(context, listen: false);
//         await courseRepository.uploadCourses(courses);
//         _setStatus('${courses.length} data mata kuliah berhasil diunggah.');
//       }

//     } catch (e) {
//       print('Error during CSV processing: $e');
//       _setStatus('Gagal mengunggah mata kuliah: ${e.toString()}', isError: true);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _setStatus(String message, {bool isError = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         duration: Duration(seconds: isError ? 5 : 3),
//       ),
//     );
//     setState(() {
//       _statusMessage = message;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Unggah Data CSV', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color(0xFF1E90FF),
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _isLoading ? null : _uploadCoursesCsv,
//                 icon: const Icon(Icons.school_outlined),
//                 label: const Text('Unggah Mata Kuliah'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1E90FF),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               if (_isLoading) const Center(child: CircularProgressIndicator()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }