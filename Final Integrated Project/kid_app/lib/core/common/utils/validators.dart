import 'package:kid_app/core/constants/app_strings.dart';

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.emailRequired;
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value.trim())) {
    return AppStrings.emailInvalid;
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.passwordRequired;
  }
  if (value.length < 6) {
    return AppStrings.passwordTooShort;
  }
  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return AppStrings.confirmPasswordRequired;
  }
  if (value != password) {
    return AppStrings.passwordsDoNotMatch;
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return AppStrings.nameRequired;
  }
  if (value.trim().length < 2) {
    return AppStrings.nameTooShort;
  }
  return null;
}

String? validatePin(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.pinRequired;
  }
  final pinRegex = RegExp(r'^\d{4}$');
  if (!pinRegex.hasMatch(value)) {
    return AppStrings.pinInvalid;
  }
  return null;
}
