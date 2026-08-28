import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/quiz/models/quiz_question_model.dart';

class QuizRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<QuizQuestionModel>> getQuizQuestions(String lessonId) async {
    final response = await _apiClient.get(ApiConstants.lessonQuiz(lessonId));
    final rawList = response['data'] ?? response['questions'] ?? response;
    return (rawList as List)
        .map((json) =>
            QuizQuestionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> submitQuizResult({
    required String childId,
    required String lessonId,
    required int score,
    required int totalQuestions,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.progressQuiz(childId),
      body: {
        'contentId': lessonId,
        'score': score,
      },
    );
    return response;
  }
}
