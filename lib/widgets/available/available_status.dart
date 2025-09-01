import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableStatus extends StatelessWidget {
  // ===== Init =====
  const AvailableStatus({
    super.key,
    required this.period,
    required this.isSelected,
    required this.onPeriodSelected,
  });

  // ===== Properties =====
  final Map<String, dynamic> period;
  final bool isSelected;
  final Function(int) onPeriodSelected;

  // ===== Methods =====
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
    final screenWidth = MediaQuery.of(context).size.width;
    const spacing = 20.0;
    const segmentSpacing = 2.0; // Отступ между сегментами

    double initial = period['initial'];
    double spent = period['spent'];

    double gray = spent > initial ? initial : spent; // Потрачено в пределах
    double red = spent > initial ? spent - initial : 0; // Перерасход
    double green = spent < initial ? initial - spent : 0; // Сэкономлено
    double total = initial + red; // Полная длина шкалы (учитываем перерасход)

    // Рассчитываем веса для Expanded
    int blueWeight = (initial / total * 100).round();
    int grayWeight = (gray / total * 100).round();
    int redWeight = (red / total * 100).round();
    int greenWeight = (green / total * 100).round();

    // Создаем список сегментов
    List<Widget> segments = [];
    if (blueWeight > 0) {
      segments.addAll([
        Expanded(
          flex: blueWeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 8,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: segmentSpacing),
      ]);
    }
    if (grayWeight > 0) {
      segments.addAll([
        Expanded(
          flex: grayWeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 8,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: segmentSpacing),
      ]);
    }
    if (redWeight > 0) {
      segments.addAll([
        Expanded(
          flex: redWeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 8,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: segmentSpacing),
      ]);
    }
    if (greenWeight > 0) {
      segments.addAll([
        Expanded(
          flex: greenWeight,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 8,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: segmentSpacing),
      ]);
    }

    // Удаляем последний SizedBox, если он есть
    if (segments.isNotEmpty && segments.last is SizedBox) {
      segments.removeLast();
    }

    return GestureDetector(
      onTap: () => onPeriodSelected(0), // Всегда 0, так как один период
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            // Верхняя часть: Overspend/Economy и Expected Spending
            Row(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expected spending',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${initial.toStringAsFixed(0)}',
                      style: GoogleFonts.lato(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            // Период и индикатор
            Stack(
              children: [
                Text(
                  period['label'],
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    bottom: -4,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 2,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            // Сегменты в Row
            Row(
              children: segments,
            ),
            SizedBox(height: 8),
            // Нижняя часть: Remaining и Spent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${getRemaining(initial, spent).toStringAsFixed(0)}',
                      style: GoogleFonts.lato(fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Spent',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${spent.toStringAsFixed(0)}',
                      style: GoogleFonts.lato(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}