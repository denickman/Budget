import 'package:flutter/material.dart';

class RemainingLine extends StatelessWidget {
  final double initial;
  final double spent;
  final double Function(double, double) getRemaining;

  const RemainingLine({
    super.key,
    required this.initial,
    required this.spent,
    required this.getRemaining,
  });

  @override
  Widget build(BuildContext context) {

    final remainingFraction =
        getRemaining(initial, spent) <= 0 ? 0 : getRemaining(initial, spent) / initial;


    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: getRemaining(initial, spent) <= 0
            ? 0
            : getRemaining(initial, spent) / initial,
        child:
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              ),
            Expanded(
              child: Container(height: 2, color: Colors.grey)
            ),
          ],
        ),
        //  Container(height: 2, color: Colors.red),
      ),
    );
  }
}
