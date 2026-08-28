import 'package:flutter/material.dart';
import 'package:kid_app/features/content/models/lesson_model.dart';
import 'package:kid_app/features/content/models/subject_model.dart';
import 'package:kid_app/features/content/repositories/content_repository.dart';
import 'package:kid_app/features/quiz/models/quiz_question_model.dart';

class ContentViewmodel extends ChangeNotifier {
  final ContentRepository _repository = ContentRepository();

  List<SubjectModel> subjects = [];
  SubjectModel? currentSubject;
  LessonModel? currentLesson;
  List<QuizQuestionModel> currentQuizQuestions = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      subjects = await _repository.getSubjects();
    } catch (e) {
      errorMessage = 'Failed to load subjects. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSubject(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentSubject = await _repository.getSubjectById(id);
    } catch (e) {
      errorMessage = 'Failed to load subject. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadLesson(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentLesson = await _repository.getLessonById(id);
    } catch (e) {
      errorMessage = 'Failed to load lesson. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadLessonQuiz(String lessonId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentQuizQuestions = await _repository.getLessonQuiz(lessonId);
    } catch (e) {
      errorMessage = 'Failed to load quiz. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }
}
