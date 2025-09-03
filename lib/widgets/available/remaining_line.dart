// lib/widgets/available/remaining_line.dart
import 'package:flutter/material.dart';
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/utils/helpers.dart';

class RemainingLine extends StatelessWidget {
  final double initial;
  final double spent;

  const RemainingLine({
    super.key,
    required this.initial,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = getRemaining(initial, spent);
    final remainingFraction = remaining <= 0 ? 0.0 : remaining / initial;

    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: remainingFraction,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.dashedLine,
            ),
            Expanded(
              child: CustomPaint(
                painter: DashedLinePainter(),
                child: const SizedBox(height: 2),
              ),
            ),
          ],
        ),
      ),
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

    const dashWidth = 5.0; // Длина штриха
    const dashSpace = 3.0; // Длина промежутка
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}