class ActivityEntry {
  final String id;
  final String type;
  final String title;
  final int? score;
  final int? stars;
  final String completedAt;

  const ActivityEntry({
    required this.id,
    required this.type,
    required this.title,
    this.score,
    this.stars,
    required this.completedAt,
  });

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      score: json['score'] as int?,
      stars: json['stars'] as int?,
      completedAt: json['completedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'score': score,
      'stars': stars,
      'completedAt': completedAt,
    };
  }
}

class ProgressModel {
  final String childId;
  final List<String> lessonsCompleted;
  final Map<String, int> quizzesCompleted;
  final Map<String, int> gamesPlayed;
  final int totalStars;
  final List<ActivityEntry> recentActivity;

  const ProgressModel({
    required this.childId,
    required this.lessonsCompleted,
    required this.quizzesCompleted,
    required this.gamesPlayed,
    required this.totalStars,
    required this.recentActivity,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      childId: json['childId'] as String,
      lessonsCompleted: (json['lessonsCompleted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      quizzesCompleted: (json['quizzesCompleted'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      gamesPlayed: (json['gamesPlayed'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      totalStars: (json['totalStars'] as int?) ?? 0,
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) => ActivityEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory ProgressModel.fromProgressList(
      String childId, List<dynamic> progressList) {
    final lessons = <String>[];
    final quizzes = <String, int>{};
    final games = <String, int>{};
    var totalStars = 0;
    final activity = <ActivityEntry>[];

    for (final p in progressList) {
      final item = p as Map<String, dynamic>;
      final contentId = item['contentId'] as String;
      final contentType = item['contentType'] as String;
      final stars = (item['stars'] as int?) ?? 0;
      final score = (item['score'] as int?) ?? 0;
      final completedAt = (item['completedAt'] as String?) ?? '';

      totalStars += stars;

      switch (contentType) {
        case 'lesson':
          if (!lessons.contains(contentId)) {
            lessons.add(contentId);
          }
          activity.add(ActivityEntry(
            id: item['id'] as String? ?? contentId,
            type: 'lesson',
            title: 'Completed lesson',
            stars: stars,
            completedAt: completedAt,
          ));
          break;
        case 'quiz':
          quizzes[contentId] = score;
          activity.add(ActivityEntry(
            id: item['id'] as String? ?? contentId,
            type: 'quiz',
            title: 'Completed quiz',
            score: score,
            stars: stars,
            completedAt: completedAt,
          ));
          break;
        case 'game':
          games[contentId] = score;
          activity.add(ActivityEntry(
            id: item['id'] as String? ?? contentId,
            type: 'game',
            title: 'Played game',
            score: score,
            stars: stars,
            completedAt: completedAt,
          ));
          break;
      }
    }

    activity.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return ProgressModel(
      childId: childId,
      lessonsCompleted: lessons,
      quizzesCompleted: quizzes,
      gamesPlayed: games,
      totalStars: totalStars,
      recentActivity: activity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'lessonsCompleted': lessonsCompleted,
      'quizzesCompleted': quizzesCompleted,
      'gamesPlayed': gamesPlayed,
      'totalStars': totalStars,
      'recentActivity': recentActivity.map((e) => e.toJson()).toList(),
    };
  }
}
