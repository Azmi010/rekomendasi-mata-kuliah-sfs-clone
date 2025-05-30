// lib/widgets/all_services_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:sfs/screens/study_plan/study_plan_screen.dart';
import 'package:sfs/widgets/menu_grid_item.dart';

class AllServicesBottomSheet extends StatelessWidget {
  const AllServicesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header "Semua Layanan"
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Semua Layanan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Grid Layanan Baris 1 & 2 (Milestone sampai Telegram)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: [
              MenuGridItem(
                  icon: Icons.event_note,
                  title: 'Milestone',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.devices_other,
                  title: 'MMP',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.assessment,
                  title: 'Hasil Studi',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.description,
                  title: 'Transkrip',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.person_pin_circle,
                  title: 'Kehadiran',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.wifi,
                  title: 'Cek Kuota',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.event,
                  title: 'Event',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.telegram,
                  title: 'Telegram',
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(thickness: 1.5, color: Colors.grey),
          const SizedBox(height: 15),

          // Grid Layanan Baris 3, 4 & 5 (Kuisioner sampai Monitoring MBKM)
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: [
              MenuGridItem(
                icon: Icons.notes,
                title: 'Kuisioner',
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.red,
              ),
              MenuGridItem(
                icon: Icons.edit_note,
                title: 'Rencana Studi',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudyPlanScreen()),
                  );
                },
                iconColor: Colors.red,
              ),
              MenuGridItem(
                icon: Icons.book,
                title: 'UC3',
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.green,
              ),
              MenuGridItem(
                icon: Icons.payment,
                title: 'Payment',
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.purple,
              ),
              MenuGridItem(
                  icon: Icons.library_books,
                  title: 'Library',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.poll,
                  title: 'Survey',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                  icon: Icons.edit_document,
                  title: 'E-Signature',
                  onTap: () {
                    Navigator.pop(context);
                  }),
              MenuGridItem(
                icon: Icons.medical_services,
                title: 'Presensi Magang',
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.green,
              ),
              MenuGridItem(
                  icon: Icons.monitor,
                  title: 'Monitoring MBKM',
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
