import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Global color constants
class AppColors {
  static const Color primary = Color.fromARGB(255, 131, 57, 0);
  static const Color overspend = Colors.red;
  static const Color economy = Colors.green;
  static const Color future = Colors.blue;
  static const Color neutral = Colors.black;
  static const Color background = Colors.white;
  static const Color divider = Colors.grey;
  static const Color dashedLine = Colors.grey;
  static const Color segmentSpacing = Colors.transparent; // For spacing if needed
  static const Color iconGrey = Colors.grey;

  static Color expected = Colors.grey.shade300;
}

// Global Text styles 
class AppTextStyles {

    // for Pads (example)
    static TextStyle boldExtraLarge = GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static TextStyle boldLarge = GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle boldMedium = GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static TextStyle regularMedium = GoogleFonts.lato(
    fontSize: 14,
  );
}

// Global theme data (extend in main.dart if needed)
ThemeData getAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primary,
    ),
    textTheme: GoogleFonts.latoTextTheme(),
    dividerColor: AppColors.divider,
    iconTheme: const IconThemeData(color: AppColors.iconGrey),
  );
}

// For images/assets (if any in future)
class AppAssets {
  // static const String exampleImage = 'assets/images/example.png';
  // Add paths here as needed
}

