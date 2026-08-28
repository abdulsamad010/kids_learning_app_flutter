class GameModel {
  final String id;
  final String type;
  final String name;
  final String description;
  final String difficulty;
  final String? subjectId;
  final Map<String, dynamic> configuration;

  const GameModel({
    required this.id,
    required this.type,
    required this.name,
    this.description = '',
    this.difficulty = 'easy',
    this.subjectId,
    this.configuration = const {},
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    String? extractSubjectId(dynamic subject) {
      if (subject is Map<String, dynamic>) {
        return subject['id'] as String?;
      }
      return subject as String?;
    }

    return GameModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: (json['name'] as String?) ?? (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      difficulty: (json['difficulty'] as String?) ?? 'easy',
      subjectId: extractSubjectId(json['subjectId'] ?? json['subject']),
      configuration: (json['configuration'] as Map<String, dynamic>?) ??
          (json['gameData'] as Map<String, dynamic>?) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'subjectId': subjectId,
      'configuration': configuration,
    };
  }
}
