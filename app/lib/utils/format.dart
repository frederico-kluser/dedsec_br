/// Format a number with pt-BR thousands separator (e.g. `12.345`).
String formatNum(num n) {
  final s = n.toInt().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Format a rank as `#1.234`.
String formatRank(int n) => '#${formatNum(n)}';

/// Top percentile of a rank inside a total.
String topPercent(int rank, int total) {
  if (total == 0) return '—';
  final pct = (rank / total) * 100;
  if (pct < 0.1) return '<0,1%';
  return '${pct.toStringAsFixed(1).replaceAll('.', ',')}%';
}
