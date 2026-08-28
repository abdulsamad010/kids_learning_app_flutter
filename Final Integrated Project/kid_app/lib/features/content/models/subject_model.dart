import 'package:kid_app/features/content/models/lesson_model.dart';

class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int order;
  final List<LessonModel> lessons;

  const SubjectModel({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = 'school',
    this.color = '#4CAF50',
    this.order = 0,
    this.lessons = const [],
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      icon: (json['icon'] as String?) ?? 'school',
      color: (json['color'] as String?) ?? '#4CAF50',
      order: (json['order'] as int?) ?? 0,
      lessons: json['lessons'] != null
          ? (json['lessons'] as List<dynamic>)
              .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'order': order,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}
