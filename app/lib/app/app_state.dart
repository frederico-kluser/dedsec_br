import 'package:flutter/foundation.dart';

import '../data/forum_data.dart';
import '../models/forum.dart';
import '../models/user.dart';

/// Routes available in the app. The names mirror `screenRegistry.jsx` ids,
/// minus the desktop sidebar and loader entries (loaders live in their own
/// "showcase" stack accessible from settings → debug, optional).
enum AppRoute {
  splash,
  onb1,
  interests,
  city,
  perms,
  home,
  detail,
  generate,
  channels,
  help,
  achievements,
  forum,
  forumList,
  topic,
  newpost,
  settings,
  // loaders (showcase)
  ldTerminal,
  ldHalftone,
  ldRadar,
  ldTape,
  ldCounter,
  ldGlitch,
  ldTokens,
  ldRain,
  ldSpectrum,
  ldGlyph,
  ldTkAttn,
  ldTkBeam,
  ldTkRag,
  ldTkLayers,
}

enum AppTab { home, help, forum, settings }

/// Top-level mutable state for the prototype.
class AppState extends ChangeNotifier {
  AppState() {
    _user = DedsecUser.fresh();
    _topics = List.of(kInitialTopics);
    _replies = List.of(kInitialReplies);
  }

  // ─── identity ────────────────────────────────────────────────
  late DedsecUser _user;
  DedsecUser get user => _user;
  void setUser(DedsecUser u) {
    _user = u;
    notifyListeners();
  }

  void regenerateUser() {
    _user = _user.copyWith(seed: DedsecUser.randomSeed());
    notifyListeners();
  }

  // ─── forum topics ────────────────────────────────────────────
  late List<ForumTopic> _topics;
  List<ForumTopic> get topics => List.unmodifiable(_topics);

  void addTopic(ForumTopic t) {
    _topics = [t.copyWith(newReplies: 0, mine: true), ..._topics];
    notifyListeners();
  }

  void markTopicSeen(String id) {
    _topics = _topics.map((t) => t.id == id ? t.copyWith(newReplies: 0) : t).toList();
    notifyListeners();
  }

  // ─── replies (topic detail) ──────────────────────────────────
  late List<ForumReply> _replies;
  List<ForumReply> get replies => List.unmodifiable(_replies);

  void addReply(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _replies = [
      ..._replies,
      ForumReply(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        who: _user.pseudonym,
        seed: _user.seed,
        age: 'agora',
        body: trimmed,
        reacts: const {},
        mine: true,
      ),
    ];
    notifyListeners();
  }

  void deleteReply(String id) {
    _replies = _replies.where((r) => r.id != id).toList();
    notifyListeners();
  }

  // ─── forum navigation ────────────────────────────────────────
  TopicScope _forumScope = TopicScope.mun;
  TopicScope get forumScope => _forumScope;
  void setForumScope(TopicScope s) {
    _forumScope = s;
    notifyListeners();
  }

  ForumTopic? _currentTopic;
  ForumTopic? get currentTopic => _currentTopic;
  void setCurrentTopic(ForumTopic t) {
    _currentTopic = t;
    notifyListeners();
  }

  // ─── route ───────────────────────────────────────────────────
  AppRoute _route = AppRoute.splash;
  AppRoute get route => _route;
  AppTab _tab = AppTab.home;
  AppTab get tab => _tab;

  void go(AppRoute r) {
    _route = r;
    if (r == AppRoute.home) _tab = AppTab.home;
    if (r == AppRoute.help) _tab = AppTab.help;
    if (r == AppRoute.forum ||
        r == AppRoute.forumList ||
        r == AppRoute.topic ||
        r == AppRoute.newpost) {
      _tab = AppTab.forum;
    }
    if (r == AppRoute.settings) _tab = AppTab.settings;
    notifyListeners();
  }

  void goTab(AppTab t) {
    _tab = t;
    switch (t) {
      case AppTab.home:
        _route = AppRoute.home;
        break;
      case AppTab.help:
        _route = AppRoute.help;
        break;
      case AppTab.forum:
        _route = AppRoute.forum;
        break;
      case AppTab.settings:
        _route = AppRoute.settings;
        break;
    }
    notifyListeners();
  }
}
