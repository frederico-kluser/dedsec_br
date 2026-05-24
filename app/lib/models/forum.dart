/// Forum topic scope.
enum TopicScope { mun, est, fed }

TopicScope topicScopeFromId(String id) =>
    TopicScope.values.firstWhere((e) => e.name == id, orElse: () => TopicScope.mun);

class ForumTopic {
  final String id;
  final String tag;
  final TopicScope scope;
  final String title;
  final String body;
  final String author;
  final String? seed;
  final int replies;
  final String age;
  final bool live;
  final bool hot;
  final int newReplies;
  final bool mine;

  const ForumTopic({
    required this.id,
    required this.tag,
    required this.scope,
    required this.title,
    required this.body,
    required this.author,
    this.seed,
    this.replies = 0,
    this.age = 'agora',
    this.live = false,
    this.hot = false,
    this.newReplies = 0,
    this.mine = false,
  });

  ForumTopic copyWith({
    int? newReplies,
    bool? mine,
  }) =>
      ForumTopic(
        id: id,
        tag: tag,
        scope: scope,
        title: title,
        body: body,
        author: author,
        seed: seed,
        replies: replies,
        age: age,
        live: live,
        hot: hot,
        newReplies: newReplies ?? this.newReplies,
        mine: mine ?? this.mine,
      );
}

class ForumReply {
  final String id;
  final String who;
  final String? seed;
  final String age;
  final String body;
  final Map<String, int> reacts;
  final bool mine;

  const ForumReply({
    required this.id,
    required this.who,
    this.seed,
    required this.age,
    required this.body,
    this.reacts = const {},
    this.mine = false,
  });
}
