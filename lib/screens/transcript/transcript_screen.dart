import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/providers/transcript_provider.dart';
import 'package:sfs/services/course_service.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TranscriptProvider(context.read<CourseService>()),
      child: const _TranscriptView(),
    );
  }
}

class _TranscriptView extends StatefulWidget {
  const _TranscriptView();

  @override
  State<_TranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends State<_TranscriptView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<TranscriptProvider>(context);
    if (provider.statusMessage != null && provider.statusMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && provider.statusMessage != null) {
          _showSnackBar(context, provider.statusMessage!,
              isError: provider.statusMessage!.toLowerCase().contains('gagal') ||
                       provider.statusMessage!.toLowerCase().contains('error'));
          provider.clearStatusMessage();
        }
      });
    }
  }

  void _onSearchChanged() {
    Provider.of<TranscriptProvider>(context, listen: false).searchCourses(_searchController.text);
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
        duration: const Duration(seconds: 3),
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
    return Consumer<TranscriptProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Transkrip Nilai', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF1E90FF),
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: provider.isLoading 
                    ? const SizedBox(width:20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: provider.isLoading ? null : () async {
                  await provider.refreshData();
                },
                tooltip: "Perbarui Data",
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  _showSnackBar(context, 'Transkrip ini menampilkan mata kuliah yang sudah dinilai.');
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              _buildHeader(context, provider),
              Expanded(
                child: provider.isLoading && provider.filteredCourses.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filteredCourses.isEmpty && !provider.isLoading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                _searchController.text.isEmpty 
                                  ? "Belum ada mata kuliah yang dinilai untuk ditampilkan."
                                  : "Mata kuliah tidak ditemukan.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              ),
                            ),
                          )
                        : _buildCourseList(provider.filteredCourses),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TranscriptProvider provider) {
    String formattedGpa = provider.gpa.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E90FF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E90FF).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              _InfoColumn(label: 'IPK', value: formattedGpa),
              _InfoColumn(label: 'Total SKS', value: provider.totalSksEarned.toString()),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari Mata Kuliah atau Kode',
              prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<SelectedCourseDetail> courses) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _CourseGradeCard(course: course);
      },
    );
  }
}

// --- Widget ---

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _CourseGradeCard extends StatelessWidget {
  final SelectedCourseDetail course;

  const _CourseGradeCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
           ScaffoldMessenger.of(context).removeCurrentSnackBar();
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('MK: ${course.name} (${course.code}), SKS: ${course.sks}, Nilai: ${course.grade}, Semester: ${course.semesterTaken}')),
           );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${course.code} • ${course.sks} SKS',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 48,
                height: 48,
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
                  course.grade.isNotEmpty ? course.grade : "-",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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