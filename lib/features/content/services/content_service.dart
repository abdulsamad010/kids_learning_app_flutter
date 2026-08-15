import 'dart:convert';
import 'package:http/http.dart' as http;

class ContentService {
  String baseUrl = 'https://example.com/api';

  // Get lessons for a subject
  Future<List<dynamic>> getLessons(int subjectId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subjects/$subjectId/lessons'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  // Get lesson steps
  Future<List<dynamic>> getLessonSteps(
      int subjectId,
      int lessonId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/steps',
        ),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  // Get a specific lesson step
  Future<dynamic> getLessonStep(
      int subjectId,
      int lessonId,
      int lessonStepId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/subjects/$subjectId/lessons/$lessonId/steps/$lessonStepId',
        ),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }
}