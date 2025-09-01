import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableStatus extends StatelessWidget {

    // ===== Init ======
  const AvailableStatus({
    super.key,
    required this.period,
    required this.isSelected,
  });

  // ===== Properties ======
  final Map<String, dynamic> period;
  final bool isSelected;

  // ===== Methods ======
  IconData getCenterIcon(double initial, double spent) {
    if (spent > initial) return Icons.thumb_down;
    if (spent < initial) return Icons.thumb_up;
    return Icons.balance;
  }

  double getRemaining(double initial, double spent) => initial - spent;

  // ===== Lifecycle ======

  @override
  Widget build(BuildContext context) {
    double initial = period['initial'];
    double spent = period['spent'];

    double gray = spent > initial ? initial : spent;
    double red = spent > initial ? spent - initial : 0;
    double green = spent < initial ? initial - spent : 0;
    double total = initial + red;

    int blueWeight = (initial / total * 100).round();
    int grayWeight = (gray / total * 100).round();
    int redWeight = (red / total * 100).round();
    int greenWeight = (green / total * 100).round();

    const segmentSpacing = 2.0;
    List<Widget> segments = [];
    if (blueWeight > 0) {
      segments.addAll([
        Expanded(
          flex: blueWeight,
          child: ColoredSegment(color: Colors.blue),
        ),
        SizedBox(width: segmentSpacing),
      ]);
    }
    if (grayWeight > 0) {
      segments.addAll([
        Expanded(
          flex: grayWeight,
          child: ColoredSegment(color: Colors.grey),
        ),
        SizedBox(width: segmentSpacing),
      ]);
    }

    if (redWeight > 0) {
      segments.addAll([
        Expanded(
          flex: redWeight,
          child: ColoredSegment(color: Colors.red),
        ),
        SizedBox(width: segmentSpacing),
      ]);
    }

    if (greenWeight > 0) {
      segments.addAll([
        Expanded(
          flex: greenWeight,
          child: ColoredSegment(color: Colors.green),
        ),
        SizedBox(width: segmentSpacing),
      ]);
    }
    if (segments.isNotEmpty && segments.last is SizedBox) segments.removeLast();

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
          Row(children: segments),
          SizedBox(height: 4),

          RemainingSpentRow(
            initial: initial,
            spent: spent,
            getRemaining: getRemaining,
          ),
        ],
      ),
    );
  }
}

// Segment line
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

// Top line - economy / overspend + expected spending
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

// Bottom info - remaining & actual spending
class RemainingSpentRow extends StatelessWidget {
  final double initial;
  final double spent;
  final double Function(double, double) getRemaining;

  const RemainingSpentRow({
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

// label + value
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
