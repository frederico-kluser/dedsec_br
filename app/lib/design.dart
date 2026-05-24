// design.dart — color palette, typography stacks and moderation helpers.
// Mirrors layout_html_format/src/constants/{colors,fonts,moderation}.jsx.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette. Names match the React `COL` object 1:1.
class Col {
  static const bg = Color(0xFF050505);
  static const bg2 = Color(0xFF0D0D0D);
  static const panel = Color(0xFF141414);
  static const panelHi = Color(0xFF1C1C1C);
  static const ink = Color(0xFFF2F2EC);
  static const inkDim = Color(0xFF9A9A92);
  static const inkMute = Color(0xFF5A5A52);
  static const magenta = Color(0xFFFF1466);
  static const magentaD = Color(0xFFC2104F);
  static const acid = Color(0xFFB7FF2A);
  static const acidD = Color(0xFF7FB800);
  static const alert = Color(0xFFFFD60A);
  static const danger = Color(0xFFFF4936);
  static const line = Color(0xFF2A2A26);
  static const lineHi = Color(0xFF3A3A32);
  // Sky blue used in a few categories.
  static const sky = Color(0xFF7FC8FF);
}

/// Font-family helpers (Google Fonts).
class Fonts {
  static TextStyle pixel({double size = 12, Color color = Col.ink, double letterSpacing = 1, FontWeight? weight}) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color, letterSpacing: letterSpacing, fontWeight: weight, height: 1.0);
  static TextStyle stencil({double size = 40, Color color = Col.ink, double letterSpacing = 1, double height = 0.9}) =>
      GoogleFonts.anton(fontSize: size, color: color, letterSpacing: letterSpacing, height: height);
  static TextStyle mono({double size = 12, Color color = Col.ink, double letterSpacing = 0.5, double height = 1.4, FontWeight? weight}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color, letterSpacing: letterSpacing, height: height, fontWeight: weight);
  static TextStyle body({double size = 14, Color color = Col.ink, double letterSpacing = 0, double height = 1.4, FontWeight? weight}) =>
      GoogleFonts.spaceGrotesk(fontSize: size, color: color, letterSpacing: letterSpacing, height: height, fontWeight: weight);
}

/// Mock moderation classifier (matches React `moderateText`).
class ModerationResult {
  final bool blocked;
  final String word;
  const ModerationResult({required this.blocked, this.word = ''});
}

const blockedWords = <String>['shit'];

ModerationResult moderateText(String text) {
  final lower = text.toLowerCase();
  for (final w in blockedWords) {
    if (lower.contains(w)) return ModerationResult(blocked: true, word: w);
  }
  return const ModerationResult(blocked: false);
}

/// Build the dark Material theme so Scaffolds and overlays look right.
ThemeData buildDedsecTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Col.bg,
      useMaterial3: true,
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: Col.magenta,
        secondary: Col.acid,
        surface: Col.bg,
        error: Col.danger,
      ),
    );

/// Brazilian pt-BR number formatting (mimics `(n).toLocaleString('pt-BR')`).
String formatNum(num n) {
  final s = n.toInt().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String formatRank(num n) => '#${formatNum(n)}';

String topPercent(num rank, num total) {
  if (total == 0) return '—';
  final pct = (rank / total) * 100;
  if (pct < 0.1) return '<0,1%';
  return '${pct.toStringAsFixed(1).replaceAll('.', ',')}%';
}
