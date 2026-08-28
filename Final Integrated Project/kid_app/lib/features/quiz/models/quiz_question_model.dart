class QuizOption {
  final String id;
  final String text;

  const QuizOption({
    required this.id,
    required this.text,
  });

  factory QuizOption.fromJson(dynamic json) {
    if (json is String) {
      return QuizOption(id: json, text: json);
    }
    if (json is Map<String, dynamic>) {
      return QuizOption(
        id: (json['id'] as String?) ?? json['text'] as String? ?? '',
        text: (json['text'] as String?) ?? json['id'] as String? ?? '',
      );
    }
    return QuizOption(id: json.toString(), text: json.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class MatchingPair {
  final String left;
  final String right;

  const MatchingPair({
    required this.left,
    required this.right,
  });

  factory MatchingPair.fromJson(Map<String, dynamic> json) {
    return MatchingPair(
      left: json['left'] as String,
      right: json['right'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'right': right,
    };
  }
}

class QuizQuestionModel {
  final String id;
  final String lessonId;
  final String type;
  final String question;
  final List<QuizOption>? options;
  final String correctAnswer;
  final String? explanation;
  final List<MatchingPair>? matchingPairs;
  final int points;

  const QuizQuestionModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.explanation,
    this.matchingPairs,
    required this.points,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String,
      lessonId: (json['lessonId'] as String?) ?? '',
      type: json['type'] as String,
      question: json['question'] as String,
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
              .map((e) => QuizOption.fromJson(e))
              .toList()
          : null,
      correctAnswer: json['correctAnswer']?.toString() ?? '',
      explanation: json['explanation'] as String?,
      matchingPairs: json['matchingPairs'] != null
          ? (json['matchingPairs'] as List<dynamic>)
              .map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      points: (json['points'] as int?) ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'type': type,
      'question': question,
      'options': options?.map((e) => e.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'matchingPairs': matchingPairs?.map((e) => e.toJson()).toList(),
      'points': points,
    };
  }
}
