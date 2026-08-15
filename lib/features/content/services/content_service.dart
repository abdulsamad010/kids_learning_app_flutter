import 'dart:convert';
import 'package:http/http.dart' as http;

class ContentService {
  String baseUrl = 'https://example.com/api';


  Future<List<dynamic>> getSubjects() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subjects'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }


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
}