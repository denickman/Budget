import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:finapp/widgets/available/available_status.dart';

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
  final spentWithinBudget = spent > initial ? initial : spent;
  final overspent = spent > initial ? spent - initial : 0;
  final saved = spent < initial ? initial - spent : 0;

  PieChartSectionData makeSection(double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: circleSize * 0.30,
      showTitle: false,
    );
  }

  return [
    if (spentWithinBudget > 0) makeSection(spentWithinBudget, Colors.grey),
    if (overspent > 0) makeSection(overspent.toDouble(), Colors.red),                  
    if (saved > 0) makeSection(saved.toDouble(), Colors.green),                       
    makeSection(initial, Colors.blue),                                     
  ];
}


  IconData getCenterIcon(double initial, double spent) {
    if (spent > initial) return Icons.thumb_down;
    if (spent < initial) return Icons.thumb_up;
    return Icons.balance;
  }

  double getRemaining(double initial, double spent) {
    return initial - spent;
  }

  Widget _showAvailableStatus() {
    if (_selectedPeriodIndex == null) {
      return Container(); // Пустой контейнер, если период не выбран
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: AvailableStatus(
        period: periods[_selectedPeriodIndex!],
        isSelected: true,
        onPeriodSelected: (index) => setState(() => _selectedPeriodIndex = index),
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
                SizedBox(height: 5),
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

  // ===== Lifecycle ======

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Available Budget',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  setState(() => _isExpanded = !_isExpanded);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: _buildPeriodCircles(context),
            ),
            if (_isExpanded) _showAvailableStatus(),
          ],
        ),
      ),
    );
  }
}