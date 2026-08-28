import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/games/models/game_model.dart';

class GameRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<GameModel>> getGames() async {
    final response = await _apiClient.get(ApiConstants.games);
    final rawList = response['data'] ?? response['games'] ?? response;
    return (rawList as List).map((e) => GameModel.fromJson(e)).toList();
  }

  Future<GameModel> getGameById(String id) async {
    final response = await _apiClient.get(ApiConstants.gameById(id));
    final data = response['data'] ?? response;
    return GameModel.fromJson(data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> submitGameResult({
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
}
