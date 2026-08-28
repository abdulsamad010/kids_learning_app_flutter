import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/features/child/models/child_model.dart';

class ChildRepository {
  final ApiClient _api = ApiClient.instance;

  Future<List<ChildModel>> getChildren() async {
    final json = await _api.get(ApiConstants.children);
    final data = json['data'];
    if (data is List) {
      return data
          .map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ChildModel> getChild(String childId) async {
    final json = await _api.get(ApiConstants.childById(childId));
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return ChildModel.fromJson(data);
    }
    throw ApiException(
      statusCode: 200,
      message: 'Failed to parse child data.',
    );
  }

  Future<ChildModel> createChild({
    required String name,
    required int age,
    required String avatar,
    required String learningLevel,
  }) async {
    final json = await _api.post(
      ApiConstants.children,
      body: {
        'nickname': name,
        'age': age,
        'avatar': avatar,
        'learningLevel': learningLevel,
      },
    );
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return ChildModel.fromJson(data);
    }
    throw ApiException(
      statusCode: 200,
      message: 'Failed to parse created child data.',
    );
  }

  Future<ChildModel> updateChild(
    String childId, {
    String? name,
    int? age,
    String? avatar,
    String? learningLevel,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['nickname'] = name;
    if (age != null) body['age'] = age;
    if (avatar != null) body['avatar'] = avatar;
    if (learningLevel != null) body['learningLevel'] = learningLevel;

    final json = await _api.put(
      ApiConstants.childById(childId),
      body: body,
    );
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return ChildModel.fromJson(data);
    }
    throw ApiException(
      statusCode: 200,
      message: 'Failed to parse updated child data.',
    );
  }

  Future<void> deleteChild(String childId) async {
    await _api.delete(ApiConstants.childById(childId));
  }
}
