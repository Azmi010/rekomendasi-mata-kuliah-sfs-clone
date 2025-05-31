import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/models/course.dart';
import 'package:sfs/services/course_service.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  AddCourseScreenState createState() => AddCourseScreenState();
}

class AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Course> allCourses = [];
  List<Course> filteredCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
    });
    final courseService = Provider.of<CourseService>(context, listen: false);
    allCourses = await courseService.getCourses();
    _filterCourses();
    setState(() {
      _isLoading = false;
    });
  }

  void _filterCourses() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      filteredCourses = allCourses
          .where((course) =>
              course.code.toLowerCase().contains(searchTerm) ||
              course.name.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Kolom Pencarian
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
            
            // Daftar Mata Kuliah
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: filteredCourses.isEmpty
                        ? const Center(child: Text('Tidak ada mata kuliah yang ditemukan.'))
                        : ListView.builder(
                            itemCount: filteredCourses.length,
                            itemBuilder: (context, index) {
                              final course = filteredCourses[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Text(
                                    course.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('${course.code} | ${course.sks} | ${course.type}'),
                                  trailing: const Icon(Icons.add_circle_outline, color: Color(0xFF1E90FF)),
                                  onTap: () {
                                    Navigator.pop(context, course); 
                                  },
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}