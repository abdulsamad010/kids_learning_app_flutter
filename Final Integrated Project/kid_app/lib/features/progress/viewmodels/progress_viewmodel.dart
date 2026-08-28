import 'package:flutter/material.dart';
import 'package:kid_app/features/progress/models/progress_model.dart';
import 'package:kid_app/features/progress/repositories/progress_repository.dart';

class ProgressViewmodel extends ChangeNotifier {
  final ProgressRepository _repository = ProgressRepository();

  ProgressModel? progress;
  Map<String, dynamic>? summary;
  bool isLoading = false;
  String? errorMessage;
  List<Map<String, dynamic>> syncQueue = [];

  Future<void> loadProgress(String childId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      progress = await _repository.getProgress(childId);
    } catch (e) {
      errorMessage = 'Failed to load progress.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSummary(String childId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summary = await _repository.getProgressSummary(childId);
    } catch (e) {
      errorMessage = 'Failed to load summary.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> submitLesson({
    required String childId,
    required String lessonId,
    required int stars,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitLessonProgress(
        childId: childId,
        lessonId: lessonId,
        stars: stars,
      );
      await loadProgress(childId);
    } catch (e) {
      errorMessage = 'Failed to submit lesson progress.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> submitQuiz({
    required String childId,
    required String quizId,
    required int score,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitQuizProgress(
        childId: childId,
        quizId: quizId,
        score: score,
      );
      await loadProgress(childId);
    } catch (e) {
      errorMessage = 'Failed to submit quiz progress.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> submitGame({
    required String childId,
    required String gameId,
    required int score,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitGameProgress(
        childId: childId,
        gameId: gameId,
        score: score,
      );
      await loadProgress(childId);
    } catch (e) {
      errorMessage = 'Failed to submit game progress.';
    }

    isLoading = false;
    notifyListeners();
  }

  void addToSyncQueue(Map<String, dynamic> item) {
    syncQueue.add(item);
    notifyListeners();
  }

  Future<void> syncOfflineProgress(String childId) async {
    if (syncQueue.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.syncProgress(childId, syncQueue);
      syncQueue.clear();
    } catch (e) {
      errorMessage = 'Failed to sync offline progress.';
    }

    isLoading = false;
    notifyListeners();
  }
}
