import 'package:flutter/material.dart';

import 'achievements.dart';
import 'topics.dart';
import 'user.dart';

/// Central app state. Replaces the React `useAppState` + `useTopics` +
/// `useUser` + `useForumNav` + `useAchievements` hooks.
class DedsecAppState extends ChangeNotifier {
  DedsecUser _user = DedsecUser.fresh();
  List<ForumTopic> _topics = List.of(initialTopics);
  List<ForumReply> _topicReplies = List.of(initialReplies);
  TopicScope _forumScope = TopicScope.mun;
  ForumTopic? _currentTopic;
  String _tab = 'home';
  final Set<String> _ownedBadges = Set.of(initialOwnedBadges);
  final Set<String> _unopenedBadges = Set.of(initialUnopenedBadges);

  DedsecUser get user => _user;
  List<ForumTopic> get topics => List.unmodifiable(_topics);
  List<ForumReply> get topicReplies => List.unmodifiable(_topicReplies);
  TopicScope get forumScope => _forumScope;
  ForumTopic? get currentTopic => _currentTopic;
  String get tab => _tab;
  Set<String> get ownedBadges => Set.unmodifiable(_ownedBadges);
  Set<String> get unopenedBadges => Set.unmodifiable(_unopenedBadges);
  int get ownedCount => _ownedBadges.length;

  // ── user ─────────────────────────────────────────────
  void regenerateUser() {
    _user = _user.copyWith(seed: randomSeed());
    notifyListeners();
  }

  // ── topics ───────────────────────────────────────────
  void addTopic(ForumTopic t) {
    _topics = [t.copyWith(mine: true, newReplies: 0), ..._topics];
    notifyListeners();
  }

  void markTopicSeen(String id) {
    _topics = _topics
        .map((t) => t.id == id ? t.copyWith(newReplies: 0) : t)
        .toList();
    notifyListeners();
  }

  void addReply(String text) {
    final body = text.trim();
    if (body.isEmpty) return;
    _topicReplies = [
      ..._topicReplies,
      ForumReply(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        who: _user.pseudonym,
        seed: _user.seed,
        age: 'agora',
        body: body,
        mine: true,
      ),
    ];
    notifyListeners();
  }

  void deleteReply(String id) {
    _topicReplies = _topicReplies.where((r) => r.id != id).toList();
    notifyListeners();
  }

  // ── forum nav ────────────────────────────────────────
  void setForumScope(TopicScope s) {
    _forumScope = s;
    notifyListeners();
  }

  void setCurrentTopic(ForumTopic? t) {
    _currentTopic = t;
    notifyListeners();
  }

  // ── tabs ─────────────────────────────────────────────
  void setTab(String t) {
    _tab = t;
    notifyListeners();
  }

  // ── achievements ────────────────────────────────────
  void openBadge(String id) {
    if (_unopenedBadges.remove(id)) notifyListeners();
  }
}

/// Inherited widget so any descendant can read the state.
class DedsecScope extends InheritedNotifier<DedsecAppState> {
  const DedsecScope({super.key, required DedsecAppState super.notifier, required super.child});

  static DedsecAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DedsecScope>();
    assert(scope != null, 'DedsecScope missing in widget tree');
    return scope!.notifier!;
  }
}
