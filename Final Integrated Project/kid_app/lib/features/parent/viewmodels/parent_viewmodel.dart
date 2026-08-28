import 'package:flutter/material.dart';

class ParentViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isParentGatePassed = false;

  bool verifyParentPin(String pin) {
    final isValid = RegExp(r'^\d{4}$').hasMatch(pin);
    if (isValid) {
      isParentGatePassed = true;
      notifyListeners();
    }
    return isValid;
  }

  void resetParentGate() {
    isParentGatePassed = false;
    notifyListeners();
  }

  void passParentGate() {
    isParentGatePassed = true;
    notifyListeners();
  }
}
