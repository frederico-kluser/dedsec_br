/// Mock local moderation classifier. Replace with on-device LLM call.
const List<String> kBlockedWords = ['shit'];

class ModerationResult {
  final bool blocked;
  final String? word;
  const ModerationResult({required this.blocked, this.word});
}

ModerationResult moderateText(String text) {
  final lower = text.toLowerCase();
  for (final w in kBlockedWords) {
    if (lower.contains(w)) return ModerationResult(blocked: true, word: w);
  }
  return const ModerationResult(blocked: false);
}
