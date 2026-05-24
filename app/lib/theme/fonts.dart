import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Font stacks ported from `constants/fonts.jsx` (FONT).
///
/// Each helper returns a [TextStyle] you can chain with `.copyWith(...)`.
abstract final class FONT {
  static TextStyle pixel({
    double size = 11,
    Color color = COL.ink,
    double letterSpacing = 1,
    FontWeight? weight,
    TextDecoration? decoration,
    double? height,
  }) =>
      GoogleFonts.pressStart2p(
        fontSize: size,
        color: color,
        letterSpacing: letterSpacing,
        fontWeight: weight,
        decoration: decoration,
        height: height,
      );

  static TextStyle stencil({
    double size = 40,
    Color color = COL.ink,
    double letterSpacing = 1,
    double height = 0.95,
    List<Shadow>? shadows,
  }) =>
      GoogleFonts.anton(
        fontSize: size,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        shadows: shadows,
      );

  static TextStyle mono({
    double size = 11,
    Color color = COL.ink,
    double letterSpacing = 0,
    FontWeight? weight,
    double? height,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color,
        letterSpacing: letterSpacing,
        fontWeight: weight,
        height: height,
        decoration: decoration,
      );

  static TextStyle body({
    double size = 14,
    Color color = COL.ink,
    FontWeight? weight,
    double height = 1.45,
    double letterSpacing = 0,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
      );
}
