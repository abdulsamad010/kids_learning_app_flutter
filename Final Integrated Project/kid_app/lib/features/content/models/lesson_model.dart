class LessonStep {
  final int stepNumber;
  final String type;
  final String title;
  final String content;
  final String? mediaUrl;
  final Map<String, dynamic>? activityData;

  const LessonStep({
    required this.stepNumber,
    required this.type,
    required this.title,
    required this.content,
    this.mediaUrl,
    this.activityData,
  });

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    String extractContent(dynamic content) {
      if (content is Map<String, dynamic>) {
        return content['text'] as String? ?? content.toString();
      }
      if (content is String) return content;
      return content?.toString() ?? '';
    }

    return LessonStep(
      stepNumber: json['stepNumber'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      content: extractContent(json['content']),
      mediaUrl: json['mediaUrl'] as String?,
      activityData: json['activityData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'type': type,
      'title': title,
      'content': content,
      'mediaUrl': mediaUrl,
      'activityData': activityData,
    };
  }
}

class LessonModel {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int order;
  final List<LessonStep> steps;

  const LessonModel({
    required this.id,
    required this.subjectId,
    required this.title,
    this.description = '',
    this.order = 0,
    this.steps = const [],
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    String extractSubjectId(dynamic subject) {
      if (subject is Map<String, dynamic>) {
        return subject['id'] as String? ?? '';
      }
      return subject as String? ?? '';
    }

    return LessonModel(
      id: json['id'] as String,
      subjectId: extractSubjectId(json['subjectId'] ?? json['subject']),
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      order: (json['order'] as int?) ?? 0,
      steps: json['steps'] != null
          ? (json['steps'] as List<dynamic>)
              .map((e) => LessonStep.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'order': order,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}
