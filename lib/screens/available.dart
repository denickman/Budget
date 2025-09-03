import 'package:finapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/models/temp_data.dart';
import 'package:finapp/widgets/available/available_status.dart';
import 'package:finapp/widgets/available/period_circles.dart';

class AvailableScreen extends StatefulWidget {
  const AvailableScreen({super.key});

  @override
  State<AvailableScreen> createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  bool _isExpanded = false;
  int? _selectedPeriodIndex;

  List<TempData> get _mockPeriods {
    final now = DateTime.now();
    final locale = Localizations.localeOf(
      context,
    ).languageCode; // Получаем текущую локаль
    final String currentMonth = DateFormat.MMMM(
      locale,
    ).format(now); // Полное название месяца
    final String currentYear = DateFormat.y(locale).format(now);

    return [
      TempData(
        label: AppLocalizations.of(context)!.today,
        periodType: PeriodType.today,
        initial: 100.0,
        spent: 25.0,
      ),
      TempData(
        label: AppLocalizations.of(context)!.week,
        periodType: PeriodType.week,
        initial: 140.0,
        spent: 20.0,
      ),
      TempData(
        label: AppLocalizations.of(context)!.week,
        periodType: PeriodType.week,
        initial: 140.0,
        spent: 50.0,
      ),
      TempData(
        label:
            currentMonth, // Например, "Сентябрь" для ru или "September" для en
        periodType: PeriodType.month,
        initial: 3000.0,
        spent: 100.0,
      ),
      TempData(
        label: currentYear,
        periodType: PeriodType.year,
        initial: 10000.0,
        spent: 15000.0,
      ),
    ];
  }

  Widget _showAvailableStatus() {
    if (_selectedPeriodIndex == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: AvailableStatus(
        period: _mockPeriods[_selectedPeriodIndex!],
        isSelected: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.availableBudget,
                  style: AppTextStyles.boldLarge,
                ),
                trailing: IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: PeriodCircles(
                  periods: _mockPeriods,
                  selectedPeriodIndex: _selectedPeriodIndex,
                  onSelect: (index) =>
                      setState(() => _selectedPeriodIndex = index),
                ),
              ),
              if (_isExpanded) _showAvailableStatus(),
            ],
          ),
        ),
      ),
    );
  }
}
