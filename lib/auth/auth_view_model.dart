import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool get isAuthenticated => _authRepository.isAuthenticated;

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _authRepository.loginWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _authRepository.loginWithGoogle();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _authRepository.signUpWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      notifyListeners();
    } catch (e) {
    //  throw e;
    }
  }
}