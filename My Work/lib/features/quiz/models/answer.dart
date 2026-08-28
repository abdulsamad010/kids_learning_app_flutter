class Answer {
  final int answerId;
  final int questionId;
  final int quizId;
  final int lessonId;
  final int subjectId;
  final String answerText;
  final bool isCorrect;

  Answer({
    required this.answerId,
    required this.questionId,
    required this.quizId,
    required this.lessonId,
    required this.subjectId,
    required this.answerText,
    required this.isCorrect,
  });
}