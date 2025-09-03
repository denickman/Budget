// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get availableBudget => 'Доступный бюджет';

  @override
  String get status => 'Статус';

  @override
  String get overspend => 'Перерасход';

  @override
  String get economy => 'Экономия';

  @override
  String get expectedSpending => 'Ожидаемые расходы';

  @override
  String get remaining => 'Оставшийся';

  @override
  String get actualSpending => 'Фактические расходы';

  @override
  String get overall => 'Общий';

  @override
  String get today => 'Сегодня';

  @override
  String get week => 'Неделя';
}
