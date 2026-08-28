import 'package:flutter/material.dart';
import 'package:kid_app/features/rewards/models/reward_model.dart';
import 'package:kid_app/features/rewards/repositories/reward_repository.dart';

class RewardViewmodel extends ChangeNotifier {
  final RewardRepository _repository = RewardRepository();

  RewardModel? rewards;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadRewards(String childId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      rewards = await _repository.getRewards(childId);
    } catch (e) {
      errorMessage = 'Failed to load rewards.';
    }

    isLoading = false;
    notifyListeners();
  }
}
