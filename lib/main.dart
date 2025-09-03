import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/screens/available.dart';
import 'package:flutter/material.dart';
import 'package:finapp/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: const AvailableScreen(),
    );
  }
}