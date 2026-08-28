import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/dummy_data.dart';

class QuizService {
  String baseUrl = 'https://example.com/api';

  Future<List<dynamic>> getQuizzes(
      int subjectId,
      int lessonId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes',
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
    } catch (_) {}

    return DummyData.quizzes[lessonId] ?? [];
  }

  Future<List<dynamic>> getQuestions(
      int subjectId,
      int lessonId,
      int quizId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes/$quizId/questions',
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
    } catch (_) {}

    return DummyData.questions[quizId] ?? [];
  }

  Future<List<dynamic>> getAnswers(
      int subjectId,
      int lessonId,
      int quizId,
      int questionId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes/$quizId/questions/$questionId/answers',
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
    } catch (_) {}

    return DummyData.answers[questionId] ?? [];
  }

  Future<dynamic> getQuizProgress(
      int subjectId,
      int lessonId,
      ) async {
    try {
      final response = await http
          .get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/progress',
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
    } catch (_) {}

    final Map<String, dynamic> completedLessons =
    Map<String, dynamic>.from(
      DummyData.quizProgress['completedLessons'] ?? {},
    );

    final lessonProgress =
    completedLessons[lessonId.toString()];

    if (lessonProgress is Map) {
      return {
        'completedQuizTypes': [
          lessonProgress['quizType'],
        ],
        'completedQuizzes': 1,
        'totalQuizzes': 3,
        'score': lessonProgress['score'] ?? 0,
        'completedQuizId':
        lessonProgress['quizId'],
        'completedQuizType':
        lessonProgress['quizType'],
        'completedLessonId': lessonId,
        'quizResult':
        Map<String, dynamic>.from(
          lessonProgress,
        ),
      };
    }

    return {
      'completedQuizTypes': <String>[],
      'completedQuizzes': 0,
      'totalQuizzes': 3,
      'score': 0,
      'completedQuizId': null,
      'completedQuizType': null,
      'completedLessonId': null,
    };
  }
}