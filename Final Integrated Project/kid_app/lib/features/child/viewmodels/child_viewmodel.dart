import 'package:flutter/material.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/child/models/child_model.dart';
import 'package:kid_app/features/child/repositories/child_repository.dart';

class ChildViewModel extends ChangeNotifier {
  final ChildRepository _repository = ChildRepository();

  List<ChildModel> children = [];
  ChildModel? selectedChild;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadChildren() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      children = await _repository.getChildren();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Failed to load children. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> selectChild(ChildModel child) async {
    selectedChild = child;
    notifyListeners();
  }

  Future<void> createChild({
    required String name,
    required int age,
    required String avatar,
    required String learningLevel,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.createChild(
        name: name,
        age: age,
        avatar: avatar,
        learningLevel: learningLevel,
      );
      await loadChildren();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Failed to create child. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateChild(
    String id, {
    String? name,
    int? age,
    String? avatar,
    String? learningLevel,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateChild(
        id,
        name: name,
        age: age,
        avatar: avatar,
        learningLevel: learningLevel,
      );
      await loadChildren();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Failed to update child. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteChild(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteChild(id);
      if (selectedChild?.id == id) {
        selectedChild = null;
      }
      await loadChildren();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Failed to delete child. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }
}
