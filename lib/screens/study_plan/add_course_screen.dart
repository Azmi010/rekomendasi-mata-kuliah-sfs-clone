import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/providers/course_provider.dart';
import 'package:sfs/providers/auth_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  AddCourseScreenState createState() => AddCourseScreenState();
}

class AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userData = authProvider.userData;

      if (userData != null) {
        final courseProvider = Provider.of<CourseProvider>(context, listen: false);
        if (!_isInitialDataLoaded || courseProvider.filteredCourses.isEmpty) {
          courseProvider.fetchAndFilterCourses(userData.currentSemester, userData.prodi)
            .then((_) {
              if (mounted) {
                setState(() {
                  _isInitialDataLoaded = true;
                });
              }
            });
        }
      } else {
        if (mounted) {
          _showSnackBar(context, 'Data profil pengguna tidak tersedia. Tidak dapat memuat mata kuliah.', isError: true);
           setState(() {
             _isInitialDataLoaded = true;
           });
        }
      }
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<CourseProvider>(context, listen: false).searchCourses(_searchController.text);
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Mata Kuliah', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1E90FF),
        ),
        body: const Center(
          child: Text('Anda harus login untuk menambahkan mata kuliah.'),
        ),
      );
    }
    if ((authProvider.userData == null && ! _isInitialDataLoaded)) {
         return Scaffold(
            appBar: AppBar(title: const Text('Tambah Mata Kuliah', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E90FF), elevation: 0,),
            body: const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Memuat data pengguna...")
              ],
            )),
        );
    }
     if (authProvider.userData == null && _isInitialDataLoaded) {
        return Scaffold(
            appBar: AppBar(title: const Text('Tambah Mata Kuliah', style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFF1E90FF), elevation: 0,),
            body: const Center(child: Text("Gagal memuat data pengguna. Coba lagi nanti.")),
        );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah', style: TextStyle(color: Colors.white)),
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
              decoration: InputDecoration(
                hintText: 'Cari Kode atau Nama Mata Kuliah...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (courseProvider.isLoading && !_isInitialDataLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (courseProvider.isLoading && courseProvider.filteredCourses.isEmpty && _isInitialDataLoaded) {
                     return const Center(child: CircularProgressIndicator());
                  }

                  if (courseProvider.filteredCourses.isEmpty && _isInitialDataLoaded) {
                    return Center(
                        child: Text(
                      _searchController.text.isEmpty
                          ? 'Tidak ada mata kuliah yang sesuai untuk Anda.'
                          : 'Mata kuliah tidak ditemukan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ));
                  }
                  
                  return ListView.builder(
                    itemCount: courseProvider.filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.filteredCourses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          title: Text(
                            course.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            '${course.code} • ${course.sks} SKS • ${course.type}\nProdi: ${course.prodiMatkul}',
                            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          ),
                          isThreeLine: true,
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
              builder: (context, cp, child) {
                if (cp.statusMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && cp.statusMessage != null) {
                      _showSnackBar(
                        context,
                        cp.statusMessage!,
                        isError: !(cp.statusMessage!.contains('berhasil dimuat') || 
                                   cp.statusMessage!.contains('berhasil ditambahkan')),
                      );
                      cp.clearStatusMessage();
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
        builder: (context, cp, child) {
          return cp.selectedCourse != null
              ? FloatingActionButton.extended(
                  onPressed: cp.isLoading
                      ? null
                      : () async {
                          await cp.addSelectedCourseToUser(); 
                          if (mounted &&
                              cp.statusMessage != null &&
                              cp.statusMessage!.contains('berhasil ditambahkan')) {
                            Navigator.pop(context, true);
                          }
                        },
                  label: cp.isLoading && cp.statusMessage == 'Menambahkan mata kuliah ke daftar Anda...'
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : const Text('Tambah Mata Kuliah', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  icon: cp.isLoading && cp.statusMessage == 'Menambahkan mata kuliah ke daftar Anda...'
                      ? null
                      : const Icon(Icons.add_circle_outline_rounded),
                  backgroundColor: const Color(0xFF1E90FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}