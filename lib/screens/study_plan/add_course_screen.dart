import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  AddCourseScreenState createState() => AddCourseScreenState();
}

class AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialFetchDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      if (!_isInitialFetchDone || courseProvider.courses.isEmpty) {
        courseProvider.fetchCourses().then((_) {
          setState(() {
            _isInitialFetchDone = true;
          });
        });
      }
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<CourseProvider>(context, listen: false).searchCourses(_searchController.text);
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Data Mata Kuliah', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1E90FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text('Anda harus login untuk menambahkan mata kuliah.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Mata Kuliah', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E90FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari Mata Kuliah...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, courseProvider, child) {
                  if (courseProvider.isLoading && courseProvider.courses.isEmpty && !_isInitialFetchDone) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (courseProvider.filteredCourses.isEmpty && _isInitialFetchDone) {
                    return const Center(child: Text('Tidak ada mata kuliah yang ditemukan.'));
                  }
                   if (courseProvider.filteredCourses.isEmpty && !courseProvider.isLoading && !_isInitialFetchDone) {
                     return const Center(child: Text('Memuat data mata kuliah...'));
                  }


                  return ListView.builder(
                    itemCount: courseProvider.filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.filteredCourses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            course.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${course.code} | ${course.sks} SKS | ${course.type}'),
                          trailing: Radio<Course?>(
                            value: course,
                            groupValue: courseProvider.selectedCourse,
                            onChanged: (Course? selected) {
                              courseProvider.setSelectedCourse(selected);
                            },
                            activeColor: const Color(0xFF1E90FF),
                          ),
                          onTap: () {
                            courseProvider.setSelectedCourse(course);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                if (courseProvider.statusMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && courseProvider.statusMessage != null) {
                      _showSnackBar(
                        context,
                        courseProvider.statusMessage!,
                        isError: !courseProvider.statusMessage!.contains('berhasil dimuat') &&
                                 !courseProvider.statusMessage!.contains('berhasil ditambahkan'),
                      );
                      courseProvider.clearStatusMessage();
                    }
                  });
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          return courseProvider.selectedCourse != null
              ? FloatingActionButton.extended(
                  onPressed: courseProvider.isLoading
                      ? null
                      : () async {
                          await courseProvider.addSelectedCourseToUser(userId);
                          if (mounted &&
                              courseProvider.statusMessage != null &&
                              courseProvider.statusMessage!.contains('berhasil ditambahkan')) {
                            Navigator.pop(context, true);
                          }
                        },
                  label: courseProvider.isLoading && courseProvider.statusMessage == 'Menambahkan mata kuliah ke daftar Anda...'
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text('Tambah Mata Kuliah', style: TextStyle(fontSize: 18)),
                  icon: courseProvider.isLoading && courseProvider.statusMessage == 'Menambahkan mata kuliah ke daftar Anda...'
                      ? null
                      : const Icon(Icons.add),
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}