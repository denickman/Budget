// lib/main.dart
import 'package:finapp/constants/app_theme.dart';
import 'package:finapp/screens/available.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      home: const AvailableScreen(),
    );
  }
}