import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/rewards/models/reward_model.dart';

class RewardRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<RewardModel> getRewards(String childId) async {
    final response = await _apiClient.get(ApiConstants.rewardsChild(childId));
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return RewardModel.fromJson(data);
    }
    return RewardModel.fromJson(response);
  }
}
