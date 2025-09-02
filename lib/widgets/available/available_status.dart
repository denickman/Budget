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

  List<Widget> buildSegments(double initial, double spent) {
    double gray = spent > initial ? initial : spent;
    double red = spent > initial ? spent - initial : 0;
    double green = spent < initial ? initial - spent : 0;
    double total = initial + red;

    const segmentSpacing = 2.0;
    List<Widget> segments = [];

    int blueWeight = (initial / total * 100).round();
    int grayWeight = (gray / total * 100).round();
    int redWeight = (red / total * 100).round();
    int greenWeight = (green / total * 100).round();

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

    return segments;
  }

  Widget _buildActualSpendingLine(
  double initial,
  double spent,
  BuildContext context,
) {
  final total = initial + (spent > initial ? spent - initial : 0);
  final grayPortion = spent > initial ? initial : spent;
  final widthFactor = grayPortion / total;

  return LayoutBuilder(
    builder: (context, constraints) {
      // Используем ширину контейнера для точного позиционирования
      final containerWidth = constraints.maxWidth;

      return Stack(
        alignment: Alignment.centerRight, // Привязка к правому краю
        children: [
          // Фоновая линия (для контекста)
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Серая линия, начинающаяся справа
          FractionallySizedBox(
            widthFactor: widthFactor, // Доля линии
            alignment: Alignment.centerRight, // Выравнивание вправо
            child: Container(
              height: 4,
              color: Colors.grey,
            ),
          ),
          // Точка в начале серой линии (слева)
          Positioned(
            right: widthFactor * containerWidth, // Позиция точки относительно правого края
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  // ===== Lifecycle ======
  @override
  Widget build(BuildContext context) {
    double initial = period['initial'];
    double spent = period['spent'];

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

          _buildActualSpendingLine(initial, spent, context),

          SizedBox(height: 4),
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

// Top info row - economy / overspend + expected spending
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

// Bottom info row - remaining & actual spending
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
