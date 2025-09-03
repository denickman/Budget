import 'package:flutter/material.dart';
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/models/temp_data.dart';
import 'package:finapp/utils/helpers.dart';
import 'package:finapp/l10n/app_localizations.dart';
import 'package:finapp/widgets/available/status_segments.dart';

class AvailableStatus extends StatelessWidget {
  const AvailableStatus({
    super.key,
    required this.period,
    required this.isSelected,
  });

  final TempData period;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    double initial = period.initial;
    double spent = period.spent;
    double expected = period.expected;
    double gray = getGray(spent, expected);
    double red = getRed(spent, expected);
    double green = getGreen(expected, spent);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Divider(color: AppColors.divider, thickness: 1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.status,
              style: AppTextStyles.boldLarge,
            ),
          ),
          EconomyOrOverspendStatus(
            initial: initial,
            spent: spent,
            expected: expected,
            gray: gray,
            red: red,
            green: green,
          ),
          const SizedBox(height: 8),
          SegmentsStatus(
            initial: initial,
            spent: spent,
            expected: expected,
          ),
          const SizedBox(height: 4),
          RemainAndActualStatus(initial: initial, spent: spent),
          const SizedBox(height: 8),
          OverallInfo(initial: initial),
        ],
      ),
    );
  }
}

class EconomyOrOverspendStatus extends StatelessWidget {
  final double initial;
  final double spent;
  final double expected;
  final double gray;
  final double red;
  final double green;

  const EconomyOrOverspendStatus({
    super.key,
    required this.initial,
    required this.spent,
    required this.expected,
    required this.gray,
    required this.red,
    required this.green,
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
              spent > expected
                  ? AppLocalizations.of(context)!.overspend
                  : AppLocalizations.of(context)!.economy,
              style: AppTextStyles.boldMedium,
            ),
            Row(
              children: [
                Icon(
                  getCenterIcon(expected, spent),
                  size: 16,
                  color: spent > expected
                      ? AppColors.overspend
                      : (spent < expected
                            ? AppColors.economy
                            : AppColors.neutral),
                ),
                const SizedBox(width: 4),
                Text(
                  spent > expected
                      ? red.toStringAsFixed(0)
                      : green.toStringAsFixed(0),
                  style: AppTextStyles.regularMedium,
                ),
              ],
            ),
          ],
        ),
        LabelValueWidget(
          label: AppLocalizations.of(context)!.expectedSpending,
          value: expected,
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class RemainAndActualStatus extends StatelessWidget {
  final double initial;
  final double spent;

  const RemainAndActualStatus({
    super.key,
    required this.initial,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LabelValueWidget(
          label: AppLocalizations.of(context)!.remaining,
          value: getRemaining(initial, spent),
          alignment: CrossAxisAlignment.start,
          reverseTitlePosition: true,
        ),
        LabelValueWidget(
          label: AppLocalizations.of(context)!.actualSpending,
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

  LabelValueWidget({
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
            Text(value.toStringAsFixed(0), style: AppTextStyles.regularMedium),
            Text(label, style: AppTextStyles.boldMedium),
          ]
        : [
            Text(label, style: AppTextStyles.boldMedium),
            Text(value.toStringAsFixed(0), style: AppTextStyles.regularMedium),
          ];

    return Column(crossAxisAlignment: alignment, children: children);
  }
}

class OverallInfo extends StatelessWidget {
  final double initial;

  const OverallInfo({super.key, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.overall,
          style: AppTextStyles.boldMedium,
        ),
        Text(initial.toStringAsFixed(0), style: AppTextStyles.regularMedium),
      ],
    );
  }
}