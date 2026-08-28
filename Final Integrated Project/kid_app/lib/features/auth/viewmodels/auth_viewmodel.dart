import 'package:flutter/material.dart';
import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/features/auth/models/user_model.dart';
import 'package:kid_app/features/auth/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;
  UserModel? user;
  bool _isLoggedIn = false;
  bool _initDone = false;
  bool _justRegistered = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get initDone => _initDone;
  bool get justRegistered => _justRegistered;

  Future<void> init() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final api = ApiClient.instance;
      await api.loadToken();
      _isLoggedIn = _repository.isLoggedIn();
    } catch (e) {
      errorMessage = 'Failed to initialize auth state.';
    }

    _initDone = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    _justRegistered = false;
    notifyListeners();

    try {
      user = await _repository.login(email: email, password: password);
      _isLoggedIn = true;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Connection failed. Please check if the server is running and try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    _justRegistered = false;
    notifyListeners();

    try {
      user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      _isLoggedIn = true;
      _justRegistered = true;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Connection failed. Please check if the server is running and try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.logout();
      user = null;
      _isLoggedIn = false;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Logout failed. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> forgotPassword({required String email}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.forgotPassword(email: email);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.resetPassword(token: token, password: password);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Password reset failed. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  void clearError() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  void resetRegistrationFlag() {
    _justRegistered = false;
    notifyListeners();
  }
}
