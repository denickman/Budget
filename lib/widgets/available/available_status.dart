import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finapp/models/temp_data.dart';
import 'package:finapp/widgets/available/remaining_line.dart';
import 'dart:math' as math; // Для min/max

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
  IconData getCenterIcon(double expected, double spent) {
    if (spent > expected) return Icons.thumb_down;
    if (spent < expected) return Icons.thumb_up;
    return Icons.balance;
  }

  double getRemaining(double initial, double spent) => initial - spent;

  List<Widget> buildSegments(double initial, double spent) {
    double expected = period.expected;
    double gray = math.min(spent, expected);
    double red = math.max(0.0, spent - expected);
    double green = math.max(0.0, expected - spent);
    double future = initial - expected;
    double total = initial + red;

    const segmentSpacing = 2.0;
    List<Widget> segments = [];

    // 1. Синий сегмент (future)
    if (future > 0) {
      segments.add(
        Expanded(
          flex: (future / total * 100).round(),
          child: ColoredSegment(color: Colors.white),
        ),
      );
    }

    // 2. Зелёный сегмент (экономия)
    if (green > 0) {
      segments.add(
        Expanded(
          flex: (green / total * 100).round(),
          child: ColoredSegment(color: Colors.green),
        ),
      );
    } else {
      segments.add(SizedBox(width: segmentSpacing));
    }

    // 3. Красный сегмент (перерасход)
    if (red > 0) {
      segments.add(
        Expanded(
          flex: (red / total * 100).round(),
          child: ColoredSegment(color: Colors.red),
        ),
      );
    }

    // 4. Серый сегмент (spent up to expected)
    if (gray > 0) {
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
    double expected = period.expected;
    double gray = math.min(spent, expected);
    double red = math.max(0.0, spent - expected);
    double green = math.max(0.0, expected - spent);

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
            expected: expected,
            gray: gray,
            red: red,
            green: green,
            getCenterIcon: getCenterIcon,
          ),
          SizedBox(height: 8),

          RemainingLine(
            initial: initial,
            spent: spent,
            getRemaining: getRemaining,
          ),

          Row(children: buildSegments(initial, spent)),

          SizedBox(height: 4),
          RemainingSpentInfoRow(
            initial: initial,
            spent: spent,
            getRemaining: getRemaining,
          ),
          SizedBox(height: 8),
          OverallInfo(
            initial: initial,
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
  final double expected;
  final double gray;
  final double red;
  final double green;
  final IconData Function(double, double) getCenterIcon;

  const EconomyOverspendExpectedInfoRow({
    super.key,
    required this.initial,
    required this.spent,
    required this.expected,
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
              spent > expected ? 'Overspend' : 'Economy',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Icon(
                  getCenterIcon(expected, spent),
                  size: 16,
                  color: spent > expected
                      ? Colors.red
                      : (spent < expected ? Colors.green : Colors.black),
                ),
                SizedBox(width: 4),
                Text(
                  spent > expected
                      ? red.toStringAsFixed(0)
                      : green.toStringAsFixed(0),
                  style: GoogleFonts.lato(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        LabelValueWidget(
          label: 'Expected spending',
          value: expected,
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

class OverallInfo extends StatelessWidget {
  final double initial;

  const OverallInfo({
    super.key,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Overall',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          initial.toStringAsFixed(0),
          style: GoogleFonts.lato(fontSize: 14),
        ),
      ],
    );
  }
}