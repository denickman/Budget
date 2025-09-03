enum PeriodType { today, week, month, year }

class TempData {
  final String label; // Для отображения в UI
  final PeriodType periodType; // Для логики вычислений
  final double initial;
  final double spent;

  TempData({
    required this.label,
    required this.periodType,
    required this.initial,
    required this.spent,
  });

  double get passedFraction {
    final now = DateTime.now();

    switch (periodType) {
      case PeriodType.today:
        return 1.0; // Текущий день считается полным
      case PeriodType.week:
        return now.weekday / 7.0; // weekday: 1=понедельник, ...7=воскресенье
      case PeriodType.month:
        final totalDays = DateTime(now.year, now.month + 1, 0).day;
        return now.day / totalDays.toDouble();
      case PeriodType.year:
        final year = int.tryParse(label); // Используем label как год
        if (year == null) return 0.0;
        final isLeap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
        final totalDays = isLeap ? 366 : 365;
        if (year > now.year) return 0.0;
        if (year < now.year) return 1.0;
        final passedDays = now.difference(DateTime(year, 1, 1)).inDays + 1;
        return passedDays / totalDays.toDouble();
    }
  }

  double get expected => initial * passedFraction;
}