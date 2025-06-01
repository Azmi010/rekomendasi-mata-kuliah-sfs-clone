// // lib/screens/admin/csv_upload_screen.dart
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:csv/csv.dart';
// import 'dart:convert'; // Untuk Utf8Decoder
// import 'package:provider/provider.dart';
// import 'package:sfs/models/course.dart'; // Import model Course dan RelevantCourse
// import 'package:sfs/services/firesotore_service.dart';

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
//       _statusMessage = 'Mengunggah data mata kuliah...';
//     });

//     try {
//       final bytes = result.files.single.bytes!;
//       final csvString = const Utf8Decoder().convert(bytes);
//       List<List<dynamic>> rowsAsListOfList = const CsvToListConverter().convert(csvString);

//       if (rowsAsListOfList.isEmpty) {
//         _setStatus('File CSV mata kuliah kosong.', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }

//       // Asumsi baris pertama adalah header
//       final headers = rowsAsListOfList[0];
//       final dataRows = rowsAsListOfList.sublist(1);

//       // Cari indeks kolom berdasarkan header (lebih robust)
//       final codeIndex = headers.indexOf('kode');
//       final nameIndex = headers.indexOf('nama');
//       final typeIndex = headers.indexOf('type');
//       final sksIndex = headers.indexOf('sks');

//       if (codeIndex == -1 || nameIndex == -1 || sksIndex == -1 || typeIndex == -1) {
//         _setStatus('Header CSV mata kuliah tidak valid. Pastikan ada "kode", "nama", "type", "sks".', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }

//       List<Course> courses = [];
//       for (var row in dataRows) {
//         if (row.length > codeIndex && row.length > nameIndex && row.length > sksIndex && row.length > typeIndex) {
//           courses.add(Course(
//             code: row[codeIndex].toString().trim(),
//             name: row[nameIndex].toString().trim(),
//             sks: row[sksIndex].toString().trim(),
//             type: row[typeIndex].toString().trim(),
//           ));
//         } else {
//           print('Skipping malformed row: $row');
//         }
//       }

//       final firestoreService = Provider.of<FirestoreService>(context, listen: false);
//       await firestoreService.uploadCourses(courses);
//       _setStatus('${courses.length} mata kuliah berhasil diunggah.');
//     } catch (e) {
//       _setStatus('Gagal mengunggah mata kuliah: ${e.toString()}', isError: true);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _uploadRelevantCoursesCsv() async {
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
//       _statusMessage = 'Mengunggah data mata kuliah relevan...';
//     });

//     try {
//       final bytes = result.files.single.bytes!;
//       final csvString = const Utf8Decoder().convert(bytes);
//       List<List<dynamic>> rowsAsListOfList = const CsvToListConverter().convert(csvString);

//       if (rowsAsListOfList.isEmpty) {
//         _setStatus('File CSV mata kuliah relevan kosong.', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }

//       // Asumsi baris pertama adalah header
//       final headers = rowsAsListOfList[0];
//       final dataRows = rowsAsListOfList.sublist(1);

//       // Cari indeks kolom berdasarkan header
//       final mainCourseNameIndex = headers.indexOf('nama_mk_utama');
//       final mainCourseCodeIndex = headers.indexOf('kode_mk_utama');
//       final relevantCourseNameIndex = headers.indexOf('nama_mk_relevan');
//       final relevantCourseCodeIndex = headers.indexOf('kode_mk_relevan');

//       if (mainCourseCodeIndex == -1 || relevantCourseCodeIndex == -1 || mainCourseNameIndex == -1 || relevantCourseNameIndex == -1) {
//         _setStatus('Header CSV mata kuliah relevan tidak valid. Pastikan ada "nama_mk_utama", "kode_mk_utama", "nama_mk_relevan", "kode_mk_relevan".', isError: true);
//         setState(() => _isLoading = false);
//         return;
//       }


//       List<RelevantCourse> relevantCourses = [];
//       for (var row in dataRows) {
//         if (row.length > mainCourseCodeIndex && row.length > relevantCourseCodeIndex && 
//             row.length > mainCourseNameIndex && row.length > relevantCourseNameIndex) {
//           relevantCourses.add(RelevantCourse(
//             mainCourseName: row[0].toString().trim(), // Asumsi nama mata kuliah utama ada di kolom pertama
//             mainCourseCode: row[mainCourseCodeIndex].toString().trim(),
//             relevantCourseName: row[2].toString().trim(), // Asumsi nama mata kuliah relevan ada di kolom kedua
//             relevantCourseCode: row[relevantCourseCodeIndex].toString().trim(),
//           ));
//         } else {
//           print('Skipping malformed row: $row');
//         }
//       }

//       final firestoreService = Provider.of<FirestoreService>(context, listen: false);
//       await firestoreService.uploadRelevantCourses(relevantCourses);
//       _setStatus('${relevantCourses.length} mata kuliah relevan berhasil diunggah.');
//     } catch (e) {
//       _setStatus('Gagal mengunggah mata kuliah relevan: ${e.toString()}', isError: true);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _setStatus(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
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
//         title: const Text('Unggah Data Firebase', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color(0xFF1E90FF),
//         elevation: 0,
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
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _isLoading ? null : _uploadCoursesCsv,
//                 icon: const Icon(Icons.upload_file),
//                 label: const Text('Unggah Data Mata Kuliah (CSV)'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1E90FF),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _isLoading ? null : _uploadRelevantCoursesCsv,
//                 icon: const Icon(Icons.upload_file),
//                 label: const Text('Unggah Data Mata Kuliah Relevan (CSV)'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               if (_isLoading) const CircularProgressIndicator(),
//               if (_statusMessage != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Text(
//                     _statusMessage!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: _statusMessage!.contains('berhasil') ? Colors.green : Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }