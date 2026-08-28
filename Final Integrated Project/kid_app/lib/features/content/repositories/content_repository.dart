import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/content/models/lesson_model.dart';
import 'package:kid_app/features/content/models/subject_model.dart';
import 'package:kid_app/features/games/models/game_model.dart';
import 'package:kid_app/features/quiz/models/quiz_question_model.dart';

class ContentRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<SubjectModel>> getSubjects() async {
    final response = await _apiClient.get(ApiConstants.subjects);
    final rawList = response['data'] ?? response['subjects'] ?? response;
    return (rawList as List)
        .map((json) => SubjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<SubjectModel> getSubjectById(String id) async {
    final response = await _apiClient.get(ApiConstants.subjectById(id));
    final data = response['data'] ?? response;
    return SubjectModel.fromJson(data as Map<String, dynamic>);
  }

  Future<LessonModel> getLessonById(String id) async {
    final response = await _apiClient.get(ApiConstants.lessonById(id));
    final data = response['data'] ?? response;
    return LessonModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<QuizQuestionModel>> getLessonQuiz(String lessonId) async {
    final response = await _apiClient.get(ApiConstants.lessonQuiz(lessonId));
    final rawList = response['data'] ?? response['questions'] ?? response;
    return (rawList as List)
        .map((json) =>
            QuizQuestionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<GameModel>> getGames() async {
    final response = await _apiClient.get(ApiConstants.games);
    final rawList = response['data'] ?? response['games'] ?? response;
    return (rawList as List)
        .map((json) => GameModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<GameModel> getGameById(String id) async {
    final response = await _apiClient.get(ApiConstants.gameById(id));
    final data = response['data'] ?? response;
    return GameModel.fromJson(data as Map<String, dynamic>);
  }
}
