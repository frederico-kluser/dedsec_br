import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typographic stacks. Wraps `google_fonts` so callers can ask for a style
/// by intent (pixel / stencil / mono / body).
class DedsecFonts {
  const DedsecFonts._();

  static TextStyle pixel({double size = 11, Color? color, double letterSpacing = 1}) =>
      GoogleFonts.pressStart2p(
        fontSize: size,
        color: color ?? DedsecColors.ink,
        letterSpacing: letterSpacing,
        height: 1.25,
      );

  static TextStyle stencil({double size = 40, Color? color, double letterSpacing = 1, double height = 0.9}) =>
      GoogleFonts.anton(
        fontSize: size,
        color: color ?? DedsecColors.ink,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle mono({
    double size = 12,
    Color? color,
    FontWeight? weight,
    double letterSpacing = 0,
    double height = 1.4,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color ?? DedsecColors.ink,
        fontWeight: weight ?? FontWeight.w400,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle body({double size = 14, Color? color, FontWeight? weight, double height = 1.45}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        color: color ?? DedsecColors.ink,
        fontWeight: weight ?? FontWeight.w400,
        height: height,
      );
}
