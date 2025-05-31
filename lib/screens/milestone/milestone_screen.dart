import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MilestoneScreen extends StatelessWidget {
  const MilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Milestone', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E90FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IPK Chart Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IPK',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0) {
                                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                                interval: 1,
                                reservedSize: 30,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0: return const Text('22231', style: TextStyle(fontSize: 10));
                                    case 1: return const Text('22232', style: TextStyle(fontSize: 10));
                                    case 2: return const Text('23241', style: TextStyle(fontSize: 10));
                                    case 3: return const Text('23242', style: TextStyle(fontSize: 10));
                                    case 4: return const Text('24251', style: TextStyle(fontSize: 10));
                                    case 5: return const Text('24252', style: TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                                reservedSize: 30,
                                interval: 1,
                              ),
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                          ),
                          minX: 0,
                          maxX: 5,
                          minY: 0,
                          maxY: 4,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 3.88),
                                FlSpot(1, 3.95),
                                FlSpot(2, 3.87),
                                FlSpot(3, 3.94),
                                FlSpot(4, 3.87),
                                FlSpot(5, 0),
                              ],
                              isCurved: false,
                              color: Colors.green,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  // Contoh titik IP Semester hijau
                                  if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4 || index == 5) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.green,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white,
                                    );
                                  }
                                  return FlDotCirclePainter(radius: 0);
                                },
                              ),
                              belowBarData: BarAreaData(show: false),
                            ),
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 3.88),
                                FlSpot(1, 3.92),
                                FlSpot(2, 3.90),
                                FlSpot(3, 3.91),
                                FlSpot(4, 3.90),
                                FlSpot(5, 3.90),
                              ],
                              isCurved: false,
                              color: Colors.orange,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  // Contoh titik IPK Kumulatif oranye
                                  if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4 || index == 5) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.orange,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white,
                                    );
                                  }
                                  return FlDotCirclePainter(radius: 0);
                                },
                              ),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(enabled: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Legenda Grafik IPK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(color: Colors.orange, text: 'IPK Semester'),
                        SizedBox(width: 20),
                        _LegendItem(color: Colors.green, text: 'IP Semester'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Statistik IPK dan IP',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SKS Bar Chart Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SKS',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.5),
                              strokeWidth: 0.5,
                            ),
                            drawVerticalLine: false,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0 && value >= 21 && value <= 24) {
                                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                                interval: 1,
                                reservedSize: 30,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0: return const Text('22231', style: TextStyle(fontSize: 10));
                                    case 1: return const Text('22232', style: TextStyle(fontSize: 10));
                                    case 2: return const Text('23241', style: TextStyle(fontSize: 10));
                                    case 3: return const Text('23242', style: TextStyle(fontSize: 10));
                                    case 4: return const Text('24251', style: TextStyle(fontSize: 10));
                                    case 5: return const Text('24252', style: TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                                reservedSize: 30,
                                interval: 1,
                              ),
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                          ),
                          barGroups: [
                            _buildBarGroup(0, 21),
                            _buildBarGroup(1, 22),
                            _buildBarGroup(2, 23),
                            _buildBarGroup(3, 24),
                            _buildBarGroup(4, 23),
                            _buildBarGroup(5, 24),
                          ],
                          minY: 20,
                          maxY: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Legenda Grafik SKS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(color: Colors.lightBlue, text: 'SKS'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Statistik SKS',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk membuat item legenda
  static Widget _LegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Helper untuk membuat BarChartGroupData
  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.lightBlue,
          width: 15,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }
}