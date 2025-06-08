import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/models/krs_semester_status.dart';
import 'package:sfs/models/selected_course_detail.dart';
import 'package:sfs/models/user_data.dart';
import 'package:sfs/providers/study_plan_provider.dart';
import 'package:sfs/screens/study_plan/add_course_screen.dart';
import 'package:sfs/services/course_service.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudyPlanProvider(context.read<CourseService>()),
      child: const _StudyPlanView(),
    );
  }
}

class _StudyPlanView extends StatefulWidget {
  const _StudyPlanView();

  @override
  State<_StudyPlanView> createState() => _StudyPlanViewState();
}

class _StudyPlanViewState extends State<_StudyPlanView> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<StudyPlanProvider>(context, listen: true);
    if (provider.statusMessage != null && provider.statusMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && provider.statusMessage != null) {
          provider.clearStatusMessage();
        }
      });
    }
  }


  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _navigateToAddCourse(BuildContext context) async {
    final studyPlanProvider = Provider.of<StudyPlanProvider>(context, listen: false);
    if (studyPlanProvider.krsStatus.isApproved || studyPlanProvider.krsStatus.isSubmitted) {
      _showSnackBar(context, "KRS sudah ${studyPlanProvider.krsStatus.isApproved ? 'disetujui' : 'dikirim'}. Tidak dapat menambah mata kuliah.", isError: true);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCourseScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyPlanProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: _buildAppBar(context, provider),
          body: _buildBodyContent(context, provider),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, StudyPlanProvider provider) {
    return AppBar(
      title: const Text('Rencana Studi', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF1E90FF),
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: provider.isLoading && provider.userData == null
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Icon(Icons.refresh, color: Colors.white),
          onPressed: provider.isLoading ? null : () async {
            await provider.refreshData();
          },
          tooltip: "Perbarui Data",
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBodyContent(BuildContext context, StudyPlanProvider provider) {
    if (provider.isLoading && provider.userData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.userData == null && !provider.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            provider.statusMessage ?? "Gagal memuat data pengguna. Pastikan Anda sudah login dan coba lagi.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 16),
          ),
        ),
      );
    }

    final UserData userData = provider.userData!;
    final KrsSemesterStatus krsStatus = provider.krsStatus;
    final List<SelectedCourseDetail> selectedCourses = provider.selectedCourses;
    final int totalSks = provider.totalSksTaken;
    const int maxSks = 24;
    final int sisaSks = maxSks - totalSks;
    final bool canEditKrs = !krsStatus.isApproved && !krsStatus.isSubmitted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16,16,16,80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AcademicHeader(userData: userData, totalSks: totalSks, sisaSks: sisaSks, maxSks: maxSks),
          const SizedBox(height: 20),
          _KrsStatusInfo(krsStatus: krsStatus),
          _CourseList(
            selectedCourses: selectedCourses,
            isLoading: provider.isLoading,
            canDelete: canEditKrs,
            onDelete: (course) => _confirmDeleteCourse(context, provider, course),
          ),
          const SizedBox(height: 24),
          _ActionButtons(
            canEditKrs: canEditKrs,
            canSubmit: selectedCourses.isNotEmpty && totalSks > 0 && sisaSks >= 0,
            krsStatus: krsStatus,
            onAddCourse: () => _navigateToAddCourse(context),
            onSubmitKrs: () => _confirmSubmitKrs(context, provider),
            onCancelKrsSubmission: () => provider.cancelKrsSubmission(),
            sisaSks: sisaSks,
            totalSksTaken: totalSks,
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCourse(BuildContext context, StudyPlanProvider provider, SelectedCourseDetail course) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Hapus Mata Kuliah'),
        content: Text('Apakah Anda yakin ingin menghapus "${course.name}" (${course.code}) dari KRS?'),
        actions: <Widget>[
          TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white),
            child: const Text('Hapus'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.deleteCourse(course.code);
            },
          ),
        ],
      ),
    );
  }

  void _confirmSubmitKrs(BuildContext context, StudyPlanProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Selesaikan Pengisian KRS'),
        content: const Text('Anda yakin ingin menyelesaikan dan mengirim KRS ini?'),
        actions: <Widget>[
          TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(dialogContext).pop()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], foregroundColor: Colors.white),
            child: const Text('Ya, Selesaikan'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.submitKrs();
            },
          ),
        ],
      ),
    );
  }
}

class _AcademicHeader extends StatelessWidget {
  final UserData userData;
  final int totalSks, sisaSks, maxSks;

  const _AcademicHeader({
    required this.userData,
    required this.totalSks,
    required this.sisaSks,
    required this.maxSks,
  });

  Widget _buildSksInfo(String label, String value, {bool highlight = false}) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      Text(value, style: TextStyle(color: highlight ? Colors.yellowAccent.shade700 : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E90FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [ BoxShadow(color: Colors.blue.withOpacity(0.3), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4)) ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mahasiswa: ${userData.name}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('NIM: ${userData.nim}', style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Semester Aktif: ${userData.currentSemester}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ]),
          const Divider(color: Colors.white30, height: 20, thickness: 0.5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildSksInfo('SKS Max', maxSks.toString()),
            _buildSksInfo('SKS Diambil', totalSks.toString()),
            _buildSksInfo('SKS Sisa', sisaSks.toString(), highlight: sisaSks < 0),
          ]),
        ],
      ),
    );
  }
}

class _KrsStatusInfo extends StatelessWidget {
  final KrsSemesterStatus krsStatus;
  const _KrsStatusInfo({required this.krsStatus});

  Widget _statusContainer({required String message, required IconData icon, required Color iconColor, required Color bgColor, required Color textColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: iconColor.withOpacity(0.5))),
      child: Row(children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(message, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> statusWidgets = [];
    if (krsStatus.isApproved) {
      statusWidgets.add(
        _statusContainer(
          message: 'KRS TELAH DISETUJUI OLEH DOSEN WALI',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green.shade700,
          bgColor: Colors.green.shade50,
          textColor: Colors.green.shade800,
        )
      );
      if (krsStatus.advisorNote != null && krsStatus.advisorNote!.isNotEmpty) {
        statusWidgets.add(const SizedBox(height: 10));
        statusWidgets.add(
           Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Catatan Dosen Wali:", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(krsStatus.advisorNote!, style: TextStyle(fontSize: 14, color: Colors.grey.shade900, fontStyle: FontStyle.italic)),
              ],
            ),
          )
        );
      }
    } else if (krsStatus.isSubmitted) {
       statusWidgets.add(
        _statusContainer(
          message: 'KRS TELAH DIKIRIM, MENUNGGU PERSETUJUAN',
          icon: Icons.hourglass_top_rounded,
          iconColor: Colors.orange.shade800,
          bgColor: Colors.orange.shade50,
          textColor: Colors.orange.shade900,
        )
      );
    }
    
    if (statusWidgets.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(children: statusWidgets),
      );
    }
    return const SizedBox.shrink();
  }
}

class _CourseList extends StatelessWidget {
  final List<SelectedCourseDetail> selectedCourses;
  final bool isLoading;
  final bool canDelete;
  final Function(SelectedCourseDetail) onDelete;

  const _CourseList({
    required this.selectedCourses,
    required this.isLoading,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && selectedCourses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (selectedCourses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Center(child: Text("Belum ada mata kuliah yang dipilih.", style: TextStyle(color: Colors.grey[600], fontSize: 15))),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedCourses.length,
      itemBuilder: (context, index) {
        final course = selectedCourses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1.5,
          shadowColor: Colors.grey.withOpacity(0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(course.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 3),
                          Text(course.code, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    if (canDelete)
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade600, size: 24),
                        onPressed: () => onDelete(course),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                        tooltip: "Hapus Mata Kuliah",
                      )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Chip(
                      label: Text(course.type, style: TextStyle(fontSize: 11.5, color: const Color(0xFF1E90FF).withBlue(180))),
                      backgroundColor: const Color(0xFF1E90FF).withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: 0.0, vertical: -2),
                    ),
                    const SizedBox(width: 10),
                    Text('${course.sks} SKS', style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool canEditKrs;
  final bool canSubmit;
  final KrsSemesterStatus krsStatus;
  final VoidCallback onAddCourse;
  final VoidCallback onSubmitKrs;
  final VoidCallback onCancelKrsSubmission;
  final int sisaSks;
  final int totalSksTaken;

  const _ActionButtons({
    required this.canEditKrs,
    required this.canSubmit,
    required this.krsStatus,
    required this.onAddCourse,
    required this.onSubmitKrs,
    required this.onCancelKrsSubmission,
    required this.sisaSks,
    required this.totalSksTaken,
  });

  @override
  Widget build(BuildContext context) {
    if (!krsStatus.isSubmitted && !krsStatus.isApproved) {
      bool isAddDisabled = sisaSks <= 0 && totalSksTaken >=24;
      return Row(children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.white,),
            label: const Text('Tambah MK'),
            onPressed: isAddDisabled ? null : onAddCourse,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E90FF), foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline_rounded, size: 20, color: Colors.white,),
            label: const Text('Selesaikan'),
            onPressed: !canSubmit ? null : onSubmitKrs,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600, foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]);
    }
    else if (krsStatus.isSubmitted && !krsStatus.isApproved) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.cancel_schedule_send_outlined, size: 20, color: Colors.red,),
          label: const Text('Batalkan Pengiriman KRS'),
          onPressed: onCancelKrsSubmission,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.red, width: 1.5)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    else if (krsStatus.isApproved) {
      return Center(child: Text("KRS semester ini telah disetujui.", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 15)));
    }
    else if (krsStatus.isSubmitted) {
       return Center(child: Text("KRS telah dikirim dan menunggu persetujuan.", style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 15)));
    }
    return const SizedBox.shrink();
  }
}