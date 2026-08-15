import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {
  String baseUrl = 'https://example.com/api';

  Future<List<dynamic>> getQuizzes(
      int subjectId,
      int lessonId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes',
        ),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }


  Future<List<dynamic>> getQuestions(
      int subjectId,
      int lessonId,
      int quizId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes/$quizId/questions',
        ),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }


  Future<List<dynamic>> getAnswers(
      int subjectId,
      int lessonId,
      int quizId,
      int questionId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/quizzes/$quizId/questions/$questionId/answers',
        ),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }
}