import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finapp/models/temp_data.dart';
import 'dart:math' as math; // Для min/max

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
  List<PieChartSectionData> getSections(TempData period, double circleSize) {
    final double expected = period.expected;
    final double overspent = math.max(0.0, period.spent - expected);
    final double saved = math.max(0.0, expected - period.spent);
    final double future = period.initial - expected;

    PieChartSectionData makeSection(
      double value,
      Color color,
      bool withBorder,
    ) {
      return PieChartSectionData(
        value: value.abs(),
        color: color,
        radius: circleSize * 0.30,
        showTitle: false,
        borderSide: withBorder
            ? BorderSide(width: 0.5, color: Colors.blue)
            : BorderSide.none,
      );
    }

    final sections = <PieChartSectionData>[];

    // 1. Grey sector = spent (up to expected), без обводки
    if (period.spent > 0) {
      sections.add(
        makeSection(math.min(period.spent, expected), Colors.grey.shade200, false),
      );
    }

    // 2. Red sector = overspent (if any), без обводки
    if (overspent > 0) {
      sections.add(makeSection(overspent, Colors.red, false));
    }

    // 3. Green sector = saved (if any), с обводкой
    if (saved > 0) {
      sections.add(makeSection(saved, Colors.green, true));
    }

    // 4. Blue sector = future budget (remaining after expected), с обводкой
    if (future > 0) {
      sections.add(makeSection(future, Colors.blue, true));
    }

    return sections;
  }

  IconData getCenterIcon(double expected, double spent) {
    if (spent > expected) return Icons.thumb_down;
    if (spent < expected) return Icons.thumb_up;
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

          // Проверяем наличие зелёного сектора (saved)
          final double saved = math.max(0.0, period.expected - period.spent);
          final double sectionsSpace = saved > 0 ? 0.0 : 2.0;

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
                              sections: getSections(period, circleSize),
                              sectionsSpace:
                                  sectionsSpace, // Динамическое расстояние
                              startDegreeOffset: -90,
                            ),
                          ),
                        ),
                        Icon(
                          getCenterIcon(period.expected, period.spent),
                          size: circleSize * 0.2,
                          color: Colors.grey,
                          // period.spent > period.expected
                          //     ? Colors.red
                          //     : (period.spent < period.expected
                          //           ? Colors.green
                          //           : Colors.black),
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
                      color: Colors.white,
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
