/// Mock local moderation. Mirrors `src/constants/moderation.jsx`.
const blockedWords = ['shit'];

class ModerationResult {
  ModerationResult({required this.blocked, this.word});
  final bool blocked;
  final String? word;
}

ModerationResult moderateText(String text) {
  final lower = text.toLowerCase();
  for (final w in blockedWords) {
    if (lower.contains(w)) {
      return ModerationResult(blocked: true, word: w);
    }
  }
  return ModerationResult(blocked: false);
}
