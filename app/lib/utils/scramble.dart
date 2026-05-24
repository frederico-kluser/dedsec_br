const _kGlyphs = r'!@#$%&*+=<>/\|0123456789ABCDEFXYZ';

/// Returns [target] with the first [lock] characters revealed and the
/// remaining characters replaced by deterministic random-looking glyphs.
String scramble(String target, int t, [int lock = 0]) {
  final buf = StringBuffer();
  for (var i = 0; i < target.length; i++) {
    final c = target[i];
    if (i < lock || c == ' ') {
      buf.write(c);
    } else {
      buf.write(_kGlyphs[(t * 7 + i * 13) % _kGlyphs.length]);
    }
  }
  return buf.toString();
}
