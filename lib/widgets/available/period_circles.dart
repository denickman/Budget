// lib/widgets/available/period_circles.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/models/temp_data.dart';
import 'package:finapp/utils/helpers.dart';

class PeriodCircles extends StatelessWidget {
  final List<TempData> periods;
  final int? selectedPeriodIndex;
  final Function(int) onSelect;

  const PeriodCircles({
    super.key,
    required this.periods,
    required this.selectedPeriodIndex,
    required this.onSelect,
  });

  List<PieChartSectionData> _getSections(TempData period, double circleSize) {
    final double expected = period.expected;
    final double overspent = getRed(period.spent, expected);
    final double saved = getGreen(expected, period.spent);
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
            ? BorderSide(width: 0.5, color: AppColors.future)
            : BorderSide.none,
      );
    }

    final sections = <PieChartSectionData>[];

    // 1. Grey sector = spent (up to expected), без обводки
    if (period.spent > 0) {
      sections.add(
        makeSection(getGray(period.spent, expected), AppColors.expected, false),
      );
    }

    // 2. Red sector = overspent (if any), без обводки
    if (overspent > 0) {
      sections.add(makeSection(overspent, AppColors.overspend, false));
    }

    // 3. Green sector = saved (if any), с обводкой
    if (saved > 0) {
      sections.add(makeSection(saved, AppColors.economy, true));
    }

    // 4. Blue sector = future budget (remaining after expected), с обводкой
    if (future > 0) {
      sections.add(makeSection(future, AppColors.future, true));
    }

    return sections;
  }

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
          final double saved = getGreen(period.expected, period.spent);
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
                              sections: _getSections(period, circleSize),
                              sectionsSpace: sectionsSpace,
                              startDegreeOffset: -90,
                            ),
                          ),
                        ),
                        Icon(
                          getCenterIcon(period.expected, period.spent),
                          size: circleSize * 0.2,
                          color: AppColors.iconGrey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      period.label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.boldMedium,
                    ),
                    Text(
                      getRemaining(
                        period.initial,
                        period.spent,
                      ).toStringAsFixed(0),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.boldMedium,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: selectedPeriodIndex == index ? 24 : 0,
                      color: AppColors.background,
                    ),
                    const SizedBox(height: 4),
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