import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AvailableScreen extends StatefulWidget {
  const AvailableScreen({super.key});

  @override
  State<AvailableScreen> createState() {
    return _AvailableScreenState();
  }
}

class _AvailableScreenState extends State<AvailableScreen> {
  // ===== Properties ======
  bool _isExpanded = false;
  int? _selectedPeriodIndex;

  List<Map<String, dynamic>> get periods {
    final now = DateTime.now();
    final String currentMonth = DateFormat.MMM().format(now);
    final String currentYear = DateFormat.y().format(now);

    return [
      {'label': 'Today', 'initial': 100.0, 'spent': 20.0},
      {'label': 'Week', 'initial': 500.0, 'spent': 600.0},
      {'label': currentMonth, 'initial': 2000.0, 'spent': 1800.0},
      {'label': currentYear, 'initial': 24000.0, 'spent': 24000.0},
    ];
  }

  // ===== Methods ======

  // Function for calculating sectors
  List<PieChartSectionData> getSections(
    double initial,
    double spent,
    double circleSize,
  ) {
    double gray = spent > initial ? initial : spent; // spent within budget
    double red = spent > initial ? spent - initial : 0; // overspending
    double green = spent < initial ? initial - spent : 0; // saved
    double white = initial; // total amount of available funds

    PieChartSectionData makeSection(double value, Color color) {
      final double radius = circleSize * 0.30;
      return PieChartSectionData(
        value: value,
        color: color,
        radius: radius,
        showTitle: false,
      );
    }

    final sections = <PieChartSectionData>[];
    if (white > 0) sections.add(makeSection(white, Colors.blue));
    if (gray > 0) sections.add(makeSection(gray, Colors.grey));
    if (red > 0) sections.add(makeSection(red, Colors.red));
    if (green > 0) sections.add(makeSection(green, Colors.green));

    return sections;
  }

  IconData getCenterIcon(double initial, double spent) {
    if (spent > initial) return Icons.thumb_down;
    if (spent < initial) return Icons.thumb_up;
    return Icons.balance;
  }

  double getRemaining(double initial, double spent) {
    return initial - spent;
  }

  Widget _buildExpandedText() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Available Budget in details',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // For creating circles
  Widget _buildPeriodCircles(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = 20.0;
    final itemsPerRow = 4;
    final availableWidth = screenWidth - (spacing * (itemsPerRow + 1));
    final circleSize = availableWidth / itemsPerRow;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      children: periods.asMap().entries.map((entry) {
        int index = entry.key;
        var period = entry.value;
        double initial = period['initial'];
        double spent = period['spent'];

        return GestureDetector(
          onTap: () => setState(() => _selectedPeriodIndex = index),
          child: SizedBox(
            width: circleSize,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: PieChart(
                        PieChartData(
                          sections: getSections(initial, spent, circleSize),
                          centerSpaceRadius: circleSize * 0.25,
                          sectionsSpace: 2,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    Icon(
                      getCenterIcon(initial, spent),
                      size: circleSize * 0.3,
                      color: spent > initial
                          ? Colors.red
                          : (spent < initial ? Colors.green : Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  period['label'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${getRemaining(initial, spent).toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 4),
                  height: 2,
                  width: _selectedPeriodIndex == index ? 24 : 0,
                  color: Colors.blue,
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }


/*
  Widget _buildPeriodCircles(BuildContext context) {
    final periods = [
      "Q1",
      "Q2",
      "Q3",
      "Q4",
      "Q5",
      "Q6",
      "Q7",
    ]; // example of initial data
    const double circleSize = 80.0;
    const double spacing = 10.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      children: periods.asMap().entries.map((entry) {
        final index = entry.key;
        final period = entry.value;

        return SizedBox(
          width: circleSize,
          height: circleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 2
                  ? Colors.blue
                  : Colors.grey[300], // example of hightlight
            ),
            child: Center(
              child: Text(
                period,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  */

  // ===== Lifecycle ======

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Available Budget'),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  setState(() => _isExpanded = !_isExpanded);
                  print('Expand DATA!');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildPeriodCircles(context),
            ),
            if (_isExpanded) _buildExpandedText(),
          ],
        ),
      ),
    );
  }
}
