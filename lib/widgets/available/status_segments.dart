import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/utils/helpers.dart';

class SegmentsStatus extends StatelessWidget {
  final double initial;
  final double spent;
  final double expected;

  const SegmentsStatus({
    super.key,
    required this.initial,
    required this.spent,
    required this.expected,
  });

  @override
  Widget build(BuildContext context) {
    double gray = getGray(spent, expected);
    double red = getRed(spent, expected);
    double green = getGreen(expected, spent);
    double future = initial - expected;
    double total = initial + red;
    // Первая пунктирная линия: покрывает gray + red (если есть) или gray + green (если есть) или gray
    double dashedLineFraction = (gray + (red > 0 ? red : green)) / total;
    // Вторая пунктирная линия: покрывает только gray
    double grayLineFraction = gray / total;

    const double segmentSpacing = 2.0;
    List<Widget> segments = [];

    if (future > 0) {
      segments.add(
        Expanded(
          flex: (future / total * 100).round(),
          child: const ColoredSegment(color: AppColors.future),
        ),
      );
    }

    bool hasAddedSpacing = false;

    if (green > 0) {
      segments.add(
        Expanded(
          flex: (green / total * 100).round(),
          child: const ColoredSegment(color: AppColors.economy),
        ),
      );
    } else {
      segments.add(const SizedBox(width: segmentSpacing));
      hasAddedSpacing = true;
    }

    if (red > 0) {
      segments.add(
        Expanded(
          flex: (red / total * 100).round(),
          child: const ColoredSegment(color: AppColors.overspend),
        ),
      );
    }

    if (gray > 0) {
      if (red == 0 && !hasAddedSpacing) {
        segments.add(const SizedBox(width: segmentSpacing));
      }
      segments.add(
        Expanded(
          flex: (gray / total * 100).round(),
          child: ColoredSegment(color: AppColors.expected),
        ),
      );
    }

    // Переворачиваем для нужного порядка (серый справа, затем красный/зелёный, синий слева)
    segments = segments.reversed.toList();

    return Column(
      children: [
        // Первая пунктирная линия
        Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: dashedLineFraction,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // const Icon(Icons.arrow_drop_down, color: AppColors.dashedLine),
                Expanded(
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                    child: const SizedBox(height: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Сегменты (справа налево визуально: серый -> красный/зелёный -> синий)
        Row(textDirection: TextDirection.rtl, children: segments),
        // Вторая пунктирная линия (покрывает только серый сегмент)
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: grayLineFraction,

            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // const Icon(Icons.arrow_drop_up, color: AppColors.dashedLine),
                Expanded(
                  child: CustomPaint(
                    painter: DashedLinePainter(),
                    child: const SizedBox(height: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.dashedLine
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double startX = size.width; // Начинаем с правого края

    while (startX > 0) {
      double endX = startX - dashWidth;
      if (endX < 0) endX = 0;
      canvas.drawLine(Offset(startX, 0), Offset(endX, 0), paint);
      startX -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
