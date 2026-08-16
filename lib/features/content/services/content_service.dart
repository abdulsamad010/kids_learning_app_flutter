import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/dummy_data.dart';

class ContentService {
  String baseUrl = 'https://example.com/api';

  Future<List<dynamic>> getSubjects() async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/subjects'),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data;
        }
      }
    } catch (e) {}

    return DummyData.subjects;
  }

  Future<List<dynamic>> getLessons(
      int subjectId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons',
        ),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data;
        }
      }
    } catch (e) {}

    return DummyData.lessons[subjectId] ?? [];
  }

  Future<List<dynamic>> getLessonSteps(
      int subjectId,
      int lessonId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/steps',
        ),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data;
        }
      }
    } catch (e) {}

    return DummyData.lessonSteps[lessonId] ?? [];
  }

  Future<bool> saveLessonProgress(
      int subjectId,
      int lessonId,
      Map<String, dynamic> quizResult,
      Map<String, dynamic> lessonProgress,
      ) async {
    final progressData = {
      'subjectId': subjectId,
      'lessonId': lessonId,
      'quizId': quizResult['quizId'],
      'quizType': quizResult['quizType'],
      'score': quizResult['score'] ?? 0,
      'totalQuestions': quizResult['totalQuestions'] ?? 0,
      'selectedAnswers': quizResult['selectedAnswers'] ?? {},
      'percentage': lessonProgress['percentage'] ?? 0,
      'passed': lessonProgress['passed'] ?? false,
      'previousLevel': lessonProgress['previousLevel'] ?? 1,
      'currentLevel': lessonProgress['currentLevel'] ?? 1,
      'levelChange': lessonProgress['levelChange'] ?? 'retain',
    };

    try {
      final response = await http
          .post(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/progress',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(progressData),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        _saveLocalProgress(
          quizResult,
          lessonProgress,
        );

        return true;
      }
    } catch (e) {}

    _saveLocalProgress(
      quizResult,
      lessonProgress,
    );

    return true;
  }

  void _saveLocalProgress(
      Map<String, dynamic> quizResult,
      Map<String, dynamic> lessonProgress,
      ) {
    final String? quizType =
    quizResult['quizType']?.toString();

    final int score =
        quizResult['score'] ?? 0;

    final int totalQuestions =
        quizResult['totalQuestions'] ?? 0;

    final int percentage =
        lessonProgress['percentage'] ?? 0;

    final List<String> completedQuizTypes =
    List<String>.from(
      DummyData.quizProgress['completedQuizTypes'] ?? [],
    );

    if (quizType != null &&
        quizType.isNotEmpty &&
        !completedQuizTypes.contains(quizType)) {
      completedQuizTypes.add(quizType);
    }

    DummyData.quizProgress['completedQuizTypes'] =
        completedQuizTypes;

    DummyData.quizProgress['completedQuizzes'] =
        completedQuizTypes.length;

    DummyData.userProgress['currentLevel'] =
        lessonProgress['currentLevel'] ?? 1;

    DummyData.userProgress['score'] =
        score;

    DummyData.userProgress['completedQuizzes'] =
        completedQuizTypes.length;

    DummyData.userProgress['totalQuizzes'] =
    3;

    DummyData.userProgress['progressPercentage'] =
        percentage;

    DummyData.userProgress['status'] =
    lessonProgress['passed'] == true
        ? 'Great Progress!'
        : 'Keep Practicing!';

    DummyData.userProgress['lastQuizResult'] =
    Map<String, dynamic>.from(
      quizResult,
    );

    DummyData.userProgress['lastLessonProgress'] =
    Map<String, dynamic>.from(
      lessonProgress,
    );
  }

  Future<dynamic> getUserProgress() async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/user/progress',
        ),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          return data;
        }
      }
    } catch (e) {}

    return DummyData.userProgress;
  }
}