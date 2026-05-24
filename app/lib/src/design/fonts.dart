import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font helpers — load Google Fonts on demand.
/// Mirrors `src/constants/fonts.jsx`.
class DFont {
  /// Press Start 2P — pixel/stencil headings.
  static TextStyle pixel({
    double size = 11,
    Color color = const Color(0xFFF2F2EC),
    double letterSpacing = 1.5,
    FontWeight weight = FontWeight.w400,
    double? height,
  }) =>
      GoogleFonts.pressStart2p(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          letterSpacing: letterSpacing,
          fontWeight: weight,
          height: height,
        ),
      );

  /// Anton — chunky display headings.
  static TextStyle stencil({
    double size = 40,
    Color color = const Color(0xFFF2F2EC),
    double letterSpacing = 1,
    double? height = 0.9,
    List<Shadow>? shadows,
  }) =>
      GoogleFonts.anton(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          shadows: shadows,
        ),
      );

  /// JetBrains Mono — code, terminal, meta.
  static TextStyle mono({
    double size = 12,
    Color color = const Color(0xFFF2F2EC),
    double letterSpacing = 0.5,
    FontWeight weight = FontWeight.w400,
    double? height,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.jetBrainsMono(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          letterSpacing: letterSpacing,
          fontWeight: weight,
          height: height,
          decoration: decoration,
        ),
      );

  /// Space Grotesk — body copy.
  static TextStyle body({
    double size = 14,
    Color color = const Color(0xFFF2F2EC),
    double letterSpacing = 0,
    FontWeight weight = FontWeight.w400,
    double? height = 1.45,
  }) =>
      GoogleFonts.spaceGrotesk(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          letterSpacing: letterSpacing,
          fontWeight: weight,
          height: height,
        ),
      );
}
