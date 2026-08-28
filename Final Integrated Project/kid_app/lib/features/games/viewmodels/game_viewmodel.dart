import 'package:flutter/material.dart';
import 'package:kid_app/features/games/models/game_model.dart';
import 'package:kid_app/features/games/repositories/game_repository.dart';

class GameViewmodel extends ChangeNotifier {
  final GameRepository _repository = GameRepository();

  List<GameModel> games = [];
  GameModel? currentGame;
  bool isLoading = false;
  String? errorMessage;
  int currentScore = 0;

  Future<void> loadGames() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      games = await _repository.getGames();
    } catch (e) {
      errorMessage = 'Failed to load games.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadGame(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentGame = await _repository.getGameById(id);
    } catch (e) {
      errorMessage = 'Failed to load game.';
    }

    isLoading = false;
    notifyListeners();
  }

  void addScore(int points) {
    currentScore += points;
    notifyListeners();
  }

  Future<void> submitGameResult(String childId, String gameId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitGameResult(
        childId: childId,
        gameId: gameId,
        score: currentScore,
      );
    } catch (e) {
      errorMessage = 'Failed to submit game result.';
    }

    isLoading = false;
    notifyListeners();
  }

  void resetGame() {
    currentScore = 0;
    notifyListeners();
  }
}
