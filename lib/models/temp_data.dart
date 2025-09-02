// Не обязательно, но для кросс-платформы
// Для min/max, но можно импортировать в виджетах

class TempData {
  final String label;
  final double initial;
  final double spent;

  TempData({
    required this.label,
    required this.initial,
    required this.spent,
  });

  double get passedFraction {
    final now = DateTime.now();

    if (label == 'Today') {
      return 1.0; // Текущий день считается полным, как единица дня
    } else if (label == 'Week') {
      return now.weekday / 7.0; // weekday: 1=понедельник, ...7=воскресенье
    } else if (label.length == 3) { // Аббревиатура месяца, напр. 'Sep'
      final totalDays = DateTime(now.year, now.month + 1, 0).day;
      return now.day / totalDays.toDouble();
    } else {
      final year = int.tryParse(label);
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