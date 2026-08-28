import 'package:flutter/material.dart';
import 'package:kid_app/features/quiz/models/quiz_question_model.dart';
import 'package:kid_app/features/quiz/repositories/quiz_repository.dart';

class QuizViewmodel extends ChangeNotifier {
  final QuizRepository _repository = QuizRepository();

  List<QuizQuestionModel> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  Map<String, String> userAnswers = {};
  String? selectedAnswer;
  bool isAnswered = false;
  bool isLoading = false;
  String? errorMessage;
  bool isCompleted = false;

  QuizQuestionModel? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  int get totalQuestions => questions.length;

  double get progress =>
      totalQuestions > 0 ? (currentQuestionIndex + 1) / totalQuestions : 0;

  Future<void> loadQuestions(String lessonId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      questions = await _repository.getQuizQuestions(lessonId);
    } catch (e) {
      errorMessage = 'Failed to load questions. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  void submitAnswer() {
    if (selectedAnswer == null || currentQuestion == null) return;

    userAnswers[currentQuestion!.id] = selectedAnswer!;
    if (selectedAnswer == currentQuestion!.correctAnswer) {
      score++;
    }
    isAnswered = true;
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      selectedAnswer = null;
      isAnswered = false;
      notifyListeners();
    } else {
      isCompleted = true;
      notifyListeners();
    }
  }

  Future<void> submitQuizResult(String childId, String lessonId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitQuizResult(
        childId: childId,
        lessonId: lessonId,
        score: score,
        totalQuestions: totalQuestions,
      );
    } catch (e) {
      errorMessage = 'Failed to submit quiz result. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  void resetQuiz() {
    questions = [];
    currentQuestionIndex = 0;
    score = 0;
    userAnswers = {};
    selectedAnswer = null;
    isAnswered = false;
    isLoading = false;
    errorMessage = null;
    isCompleted = false;
    notifyListeners();
  }
}
