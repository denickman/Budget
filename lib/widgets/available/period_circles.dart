import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finapp/models/temp_data.dart';

class PeriodCircles extends StatelessWidget {
  // ===== Properties =====
  final List<TempData> periods;
  final int? selectedPeriodIndex;
  final Function(int) onSelect;

  // ===== Init =====
  const PeriodCircles({
    super.key,
    required this.periods,
    required this.selectedPeriodIndex,
    required this.onSelect,
  });

  // ===== Methods =====
  List<PieChartSectionData> getSections(
  double initial,
  double spent,
  double circleSize,
) {
  final overspent = spent > initial ? spent - initial : 0.0;
  final saved = spent < initial ? initial - spent : 0.0;
  final remaining = initial - spent; // Remaining can be negative (overspent) or positive (saved)

  PieChartSectionData makeSection(double value, Color color) {
    return PieChartSectionData(
      value: value.abs(), // Use absolute value to avoid negative segments
      color: color,
      radius: circleSize * 0.30,
      showTitle: false,
      borderSide: BorderSide(width: 1.0, color: Colors.black87),
    );
  }

  final sections = <PieChartSectionData>[];

  // 1. Grey sector = spent (up to initial)
  if (spent > 0) {
    sections.add(makeSection(spent > initial ? initial : spent, Colors.grey));
  }

  // 2. Red sector = overspent (if any)
  if (overspent > 0) {
    sections.add(makeSection(overspent, Colors.red));
  }

  // 3. Green sector = saved (if any)
  if (saved > 0) {
    sections.add(makeSection(saved, Colors.green));
  }

  // 4. Blue sector = remaining budget (initial amount)
  if (initial > 0) {
    sections.add(makeSection(initial, Colors.blue));
  }

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

  // ===== Lifecycle =====
 @override
Widget build(BuildContext context) {
  final spacing = 25.0;
  final circleSize = 80.0; 

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: spacing),
    child: Row(
      children: periods.asMap().entries.map((entry) {
        
        int index = entry.key;
        TempData period = entry.value;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => onSelect(index),
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
                            sections: getSections(
                              period.initial,
                              period.spent,
                              circleSize,
                            ),
                            // centerSpaceRadius: circleSize * 0.25,
                            sectionsSpace: 2,
                            startDegreeOffset: -90,
                          ),
                        ),
                      ),
                      Icon(
                        getCenterIcon(period.initial, period.spent),
                        size: circleSize * 0.2,
                        color: period.spent > period.initial
                            ? Colors.red
                            : (period.spent < period.initial
                                ? Colors.green
                                : Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    period.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    getRemaining(
                      period.initial,
                      period.spent,
                    ).toStringAsFixed(0),
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
                    width: selectedPeriodIndex == index ? 24 : 0,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}




}
