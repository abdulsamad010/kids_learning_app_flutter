class RewardEntry {
  final String id;
  final String type;
  final String title;
  final int stars;
  final String earnedAt;

  const RewardEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.stars,
    required this.earnedAt,
  });

  factory RewardEntry.fromJson(Map<String, dynamic> json) {
    return RewardEntry(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      stars: json['stars'] as int,
      earnedAt: json['earnedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'stars': stars,
      'earnedAt': earnedAt,
    };
  }
}

class RewardModel {
  final String childId;
  final int totalStars;
  final Map<String, int> lessonStars;
  final Map<String, int> quizStars;
  final Map<String, int> gameStars;
  final List<RewardEntry> recentRewards;

  const RewardModel({
    required this.childId,
    required this.totalStars,
    required this.lessonStars,
    required this.quizStars,
    required this.gameStars,
    required this.recentRewards,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    final lessonStars = <String, int>{};
    final quizStars = <String, int>{};
    final gameStars = <String, int>{};
    final recentRewards = <RewardEntry>[];

    final rewards = json['rewards'] as List<dynamic>?;
    if (rewards != null) {
      for (final r in rewards) {
        final item = r as Map<String, dynamic>;
        final sourceType = item['sourceType'] as String? ?? '';
        final sourceId = item['sourceId'] as String? ?? '';
        final stars = (item['stars'] as int?) ?? 0;
        final earnedAt = (item['earnedAt'] as String?) ?? '';

        switch (sourceType) {
          case 'lesson':
            lessonStars[sourceId] = (lessonStars[sourceId] ?? 0) + stars;
            break;
          case 'quiz':
            quizStars[sourceId] = (quizStars[sourceId] ?? 0) + stars;
            break;
          case 'game':
            gameStars[sourceId] = (gameStars[sourceId] ?? 0) + stars;
            break;
        }

        recentRewards.add(RewardEntry(
          id: item['id'] as String? ?? sourceId,
          type: sourceType,
          title: '$sourceType reward',
          stars: stars,
          earnedAt: earnedAt,
        ));
      }
    }

    return RewardModel(
      childId: json['childId'] as String? ?? '',
      totalStars: (json['totalStars'] as int?) ?? 0,
      lessonStars: lessonStars,
      quizStars: quizStars,
      gameStars: gameStars,
      recentRewards: recentRewards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'totalStars': totalStars,
      'lessonStars': lessonStars,
      'quizStars': quizStars,
      'gameStars': gameStars,
      'recentRewards': recentRewards.map((e) => e.toJson()).toList(),
    };
  }
}
