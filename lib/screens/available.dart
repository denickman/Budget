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

  List<Map<String, dynamic>> get mockPeriods {
    final now = DateTime.now();
    final String currentMonth = DateFormat.MMM().format(now);
    final String currentYear = DateFormat.y().format(now);

    final int year = now.year;

    return [
      {'label': 'Today', 'initial': 100.0, 'spent': 20.0},
      {'label': 'Week', 'initial': 500.0, 'spent': 600.0},
      {'label': currentMonth, 'initial': 2000.0, 'spent': 1800.0},
      {'label': currentYear, 'initial': 24000.0, 'spent': 24000.0},
      {
        'label': '${year - 1}',
        'initial': 20000.0,
        'spent': 18000.0,
      },
      {
        'label': '${year + 1}',
        'initial': 26000.0,
        'spent': 0.0,
      },
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
        period: mockPeriods[_selectedPeriodIndex!],
        isSelected: true,
      ),
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
              child: PeriodCircles(
                periods: mockPeriods,
                selectedPeriodIndex: _selectedPeriodIndex,
                onSelect: (index) =>
                    setState(() => _selectedPeriodIndex = index),
              ),
            ),

            if (_isExpanded) _showAvailableStatus(),
          ],
        ),
      ),
    );
  }
}
