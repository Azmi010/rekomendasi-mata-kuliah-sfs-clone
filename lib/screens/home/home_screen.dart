import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs/providers/auth_provider.dart';
import 'package:sfs/screens/transcript/transcript_screen.dart';
import 'package:sfs/widgets/all_services_bottom_sheet.dart';
import 'package:sfs/widgets/menu_grid_item.dart';
import 'package:sfs/widgets/schedule_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final _userData = authProvider.userData;

    if (_userData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1E90FF)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header User Profile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xFF1E90FF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/img/logo.png', width: 50, height: 50),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Universitas Jember',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.notifications, color: Colors.white),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFF1E90FF),
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userData.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              _userData.nim,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // TODO: Implementasi QR Code
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.qr_code, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Grid Menu Utama
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                MenuGridItem(
                    icon: Icons.event_note, title: 'Milestone', onTap: () {}),
                MenuGridItem(
                    icon: Icons.devices_other, title: 'MMP', onTap: () {}),
                MenuGridItem(
                    icon: Icons.assessment, title: 'Hasil Studi', onTap: () {}),
                MenuGridItem(
                    icon: Icons.description,
                    title: 'Transkrip',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TranscriptScreen()),
                      );
                    }),
                MenuGridItem(
                    icon: Icons.person_pin_circle,
                    title: 'Kehadiran',
                    onTap: () {}),
                MenuGridItem(
                    icon: Icons.wifi, title: 'Cek Kuota', onTap: () {}),
                MenuGridItem(icon: Icons.event, title: 'Event', onTap: () {}),
                MenuGridItem(
                    icon: Icons.more_horiz,
                    title: 'More',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (BuildContext context) {
                          return const AllServicesBottomSheet();
                        },
                      );
                    }),
              ],
            ),
            const SizedBox(height: 20),

            // Jadwal Section
            Text(
              'Jadwal',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kalender Akademik',
                        style: TextStyle(
                            color: Color(0xFF1E90FF),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Mei, 2025',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final dayNames = [
                        'Sen',
                        'Sel',
                        'Rab',
                        'Kam',
                        'Jum',
                        'Sab',
                        'Min'
                      ];
                      final dayNumbers = [26, 27, 28, 29, 30, 31, 1];

                      bool isToday = (dayNumbers[index] == DateTime.now().day &&
                          DateTime.now().month == DateTime.may);

                      return Column(
                        children: [
                          Text(
                            dayNames[index],
                            style: TextStyle(
                              color:
                                  isToday ? Color(0xFF1E90FF) : Colors.black54,
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? Color(0xFF1E90FF)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              dayNumbers[index].toString(),
                              style: TextStyle(
                                color: isToday ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Jadwal Hari Ini
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jadwal Hari Ini',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implementasi lihat semua jadwal
                  },
                  child: const Text('Semua Jadwal',
                      style: TextStyle(color: Color(0xFF1E90FF))),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Item Jadwal
            ScheduleListItem(
              time: '07:50 - 10:30 WIB',
              duration: '2h 40min',
              course: 'Kecerdasan Buatan ( Kelas A)',
              room: 'RUANG KULIAH C 2.2',
              building: 'GEDUNG 24C - ILMU KOMPUTER',
            ),
          ],
        ),
      ),
    );
  }
}
