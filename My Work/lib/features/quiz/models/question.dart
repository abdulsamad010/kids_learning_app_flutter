class Question {
  final int questionId;
  final int quizId;
  final int lessonId;
  final int subjectId;
  final String questionText;
  final String type;

  Question({
    required this.questionId,
    required this.quizId,
    required this.lessonId,
    required this.subjectId,
    required this.questionText,
    required this.type,
  });
}