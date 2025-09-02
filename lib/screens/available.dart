import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:finapp/widgets/available/available_status.dart';
import 'package:finapp/widgets/available/period_circles.dart';
import 'package:finapp/models/temp_data.dart';

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

  List<TempData> get mockPeriods {
    final now = DateTime.now();
    final String currentMonth = DateFormat.MMM().format(now);
    final String currentYear = DateFormat.y().format(now);

    final int year = now.year;

    return [
      TempData(label: 'Today', initial: 100.0, spent: 25.0),
      TempData(label: 'Week', initial: 140.0, spent: 20.0),
      TempData(label: 'Week', initial: 140.0, spent: 50.0),
      TempData(label: currentMonth, initial: 3000.0, spent: 100.0),
      TempData(label: currentYear, initial: 10000.0, spent: 15000.0),
      // TempData(label: '${year + 1}', initial: 10000.0, spent: 5000.0),
      // TempData(label: '${year + 2}', initial: 10000.0, spent: 0.0),
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