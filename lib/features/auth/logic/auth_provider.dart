import 'package:flutter/material.dart';
import 'package:s_report_system/features/auth/data/repositories/auth_repositoory.dart';
import '../data/models/user_registration_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool isLoading = false;

  Future<void> register(
      UserRegistrationModel user,
      String password,
      ) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.register(user, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}