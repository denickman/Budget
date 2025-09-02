import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finapp/models/temp_data.dart';

class AvailableStatus extends StatelessWidget {
  // ===== Init ======
  const AvailableStatus({
    super.key,
    required this.period,
    required this.isSelected,
  });

  // ===== Properties ======
  final TempData period;
  final bool isSelected;

  // ===== Methods ======
  IconData getCenterIcon(double initial, double spent) {
    if (spent > initial) return Icons.thumb_down;
    if (spent < initial) return Icons.thumb_up;
    return Icons.balance;
  }

  double getRemaining(double initial, double spent) => initial - spent;

  List<Widget> buildSegments(double initial, double spent) {
    double gray = spent > initial ? initial : spent;
    double red = spent > initial ? spent - initial : 0;
    double green = spent < initial ? initial - spent : 0;
    double total = initial + red;

    const segmentSpacing = 2.0;
    List<Widget> segments = [];

    // 1. Синий сегмент (available)
    if (initial > 0) {
      segments.add(
        Expanded(
          flex: (initial / total * 100).round(),
          child: ColoredSegment(color: Colors.blue),
        ),
      );
    }

    // 2. Зелёный сегмент (экономия)
    if (green > 0) {
      // Если есть синий, зеленый с ним сливается → без SizedBox
      segments.add(
        Expanded(
          flex: (green / total * 100).round(),
          child: ColoredSegment(color: Colors.green),
        ),
      );
    } else {
      // Если зеленого нет, оставить промежуток между синим и остальными сегментами
      segments.add(SizedBox(width: segmentSpacing));
    }

    // 3. Красный сегмент (перерасход)
    if (red > 0) {
      // Красный всегда сливается с серым → без SizedBox
      segments.add(
        Expanded(
          flex: (red / total * 100).round(),
          child: ColoredSegment(color: Colors.red),
        ),
      );
    }

    // 4. Серый сегмент (spent)
    if (gray > 0) {
      // Промежуток между серым и красным только если красного нет
      if (red == 0) segments.add(SizedBox(width: segmentSpacing));
      segments.add(
        Expanded(
          flex: (gray / total * 100).round(),
          child: ColoredSegment(color: Colors.grey),
        ),
      );
    }

    return segments;
  }

  // ===== Lifecycle ======
  @override
  Widget build(BuildContext context) {
    double initial = period.initial;
    double spent = period.spent;

    double gray = spent > initial ? initial : spent;
    double red = spent > initial ? spent - initial : 0;
    double green = spent < initial ? initial - spent : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          const Divider(color: Colors.grey, thickness: 1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Status',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          EconomyOverspendExpectedInfoRow(
            initial: initial,
            spent: spent,
            gray: gray,
            red: red,
            green: green,
            getCenterIcon: getCenterIcon,
          ),
          SizedBox(height: 8),

          Row(children: buildSegments(initial, spent)),

          SizedBox(height: 4),
          RemainingSpentInfoRow(
            initial: initial,
            spent: spent,
            getRemaining: getRemaining,
          ),
        ],
      ),
    );
  }
}

class ColoredSegment extends StatelessWidget {
  final Color color;
  const ColoredSegment({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 8,
      color: color,
    );
  }
}

class EconomyOverspendExpectedInfoRow extends StatelessWidget {
  final double initial;
  final double spent;
  final double gray;
  final double red;
  final double green;
  final IconData Function(double, double) getCenterIcon;

  const EconomyOverspendExpectedInfoRow({
    super.key,
    required this.initial,
    required this.spent,
    required this.gray,
    required this.red,
    required this.green,
    required this.getCenterIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spent > initial ? 'Overspend' : 'Economy',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Icon(
                  getCenterIcon(initial, spent),
                  size: 16,
                  color: spent > initial
                      ? Colors.red
                      : (spent < initial ? Colors.green : Colors.black),
                ),
                SizedBox(width: 4),
                Text(
                  spent > initial
                      ? '${red.toStringAsFixed(0)}'
                      : '${green.toStringAsFixed(0)}',
                  style: GoogleFonts.lato(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        LabelValueWidget(
          label: 'Expected spending',
          value: initial,
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class RemainingSpentInfoRow extends StatelessWidget {
  final double initial;
  final double spent;
  final double Function(double, double) getRemaining;

  const RemainingSpentInfoRow({
    super.key,
    required this.initial,
    required this.spent,
    required this.getRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LabelValueWidget(
          label: 'Remaining',
          value: getRemaining(initial, spent),
          alignment: CrossAxisAlignment.start,
          reverseTitlePosition: true,
        ),
        LabelValueWidget(
          label: 'Actual spending',
          value: spent,
          alignment: CrossAxisAlignment.end,
          reverseTitlePosition: true,
        ),
      ],
    );
  }
}

class LabelValueWidget extends StatelessWidget {
  final String label;
  final double value;
  final CrossAxisAlignment alignment;
  final bool reverseTitlePosition;

  const LabelValueWidget({
    super.key,
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
    this.reverseTitlePosition = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = reverseTitlePosition
        ? [
            Text(
              value.toStringAsFixed(0),
              style: GoogleFonts.lato(fontSize: 14),
            ),
            Text(
              label,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ]
        : [
            Text(
              label,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: GoogleFonts.lato(fontSize: 14),
            ),
          ];

    return Column(crossAxisAlignment: alignment, children: children);
  }
}
