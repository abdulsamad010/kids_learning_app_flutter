class LessonStep {
  final int lessonStepId;
  final int lessonId;
  final int subjectId;
  final String type;
  final String title;
  final String content;

  LessonStep({
    required this.lessonStepId,
    required this.lessonId,
    required this.subjectId,
    required this.type,
    required this.title,
    required this.content,
  });
}