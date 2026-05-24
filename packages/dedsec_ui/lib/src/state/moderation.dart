class ModerationResult {
  final bool blocked;
  final String? word;
  const ModerationResult({required this.blocked, this.word});
}

const blockedWords = <String>['shit'];

ModerationResult moderateText(String text) {
  final lower = text.toLowerCase();
  for (final w in blockedWords) {
    if (lower.contains(w)) return ModerationResult(blocked: true, word: w);
  }
  return const ModerationResult(blocked: false);
}
