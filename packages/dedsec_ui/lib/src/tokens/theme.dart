import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildDedsecTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: DedsecColors.bg,
    canvasColor: DedsecColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: DedsecColors.magenta,
      secondary: DedsecColors.acid,
      surface: DedsecColors.panel,
      onSurface: DedsecColors.ink,
      error: DedsecColors.danger,
    ),
  );
  return base.copyWith(
    textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
      bodyColor: DedsecColors.ink,
      displayColor: DedsecColors.ink,
    ),
  );
}
