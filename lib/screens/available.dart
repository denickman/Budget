import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:finapp/widgets/available/available_status.dart';
import 'package:finapp/widgets/available/period_circles.dart'; // Новый импорт

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
  Widget _showAvailableStatus() {
    if (_selectedPeriodIndex == null) {
      return Container(); 
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: AvailableStatus(
        period: periods[_selectedPeriodIndex!],
        isSelected: true,
      ),
    );
  }

  Widget _buildPeriodCircles(BuildContext context) {
  final periods = [
    "Q1",
    "Q2",
    "Q3",
    "Q4",
    "Q5",
 
  ]; // пример данных
  const double circleSize = 80.0;
  const double spacing = 10.0;

  return Wrap(
    spacing: spacing,
    runSpacing: spacing,
    alignment: WrapAlignment.center,
    children: periods.asMap().entries.map((entry) {
      final index = entry.key;
      final period = entry.value;

      return GestureDetector(
        onTap: () {
          // при желании можно обрабатывать тап
          print('Tapped $period');
        },
        child: SizedBox(
          width: circleSize,
          height: circleSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 2
                  ? Colors.blue
                  : Colors.grey[300], // пример подсветки
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
            child: _buildPeriodCircles(context), // вызов старого круга
          ),



            // Padding(
            //   padding: const EdgeInsets.all(2.0),
            //   child: PeriodCircles(
            //     periods: periods,
            //     selectedPeriodIndex: _selectedPeriodIndex,
            //     onSelect: (index) => setState(() => _selectedPeriodIndex = index),
            //   ),
            // ),


            if (_isExpanded) _showAvailableStatus(),
          ],
        ),
      ),
    );
  }
}