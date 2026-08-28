import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/progress/models/progress_model.dart';

class ProgressRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<ProgressModel> getProgress(String childId) async {
    final response = await _apiClient.get(ApiConstants.progressChild(childId));
    final dataList = response['data'];
    if (dataList is List) {
      return ProgressModel.fromProgressList(childId, dataList);
    }
    return ProgressModel.fromJson(
        dataList is Map<String, dynamic> ? dataList : {});
  }

  Future<Map<String, dynamic>> getProgressSummary(String childId) async {
    final response = await _apiClient.get(ApiConstants.progressSummary(childId));
    final data = response['data'];
    return data is Map<String, dynamic> ? data : response;
  }

  Future<Map<String, dynamic>> submitLessonProgress({
    required String childId,
    required String lessonId,
    required int stars,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.progressLesson(childId),
      body: {'contentId': lessonId, 'stars': stars},
    );
    return response;
  }

  Future<Map<String, dynamic>> submitQuizProgress({
    required String childId,
    required String quizId,
    required int score,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.progressQuiz(childId),
      body: {'contentId': quizId, 'score': score},
    );
    return response;
  }

  Future<Map<String, dynamic>> submitGameProgress({
    required String childId,
    required String gameId,
    required int score,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.progressGame(childId),
      body: {'contentId': gameId, 'score': score},
    );
    return response;
  }

  Future<Map<String, dynamic>> syncProgress(
    String childId,
    List<Map<String, dynamic>> queue,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.progressSync(childId),
      body: {'records': queue},
    );
    return response;
  }
}
