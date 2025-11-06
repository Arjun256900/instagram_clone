import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user_model.dart';

class SignupNotifier extends StateNotifier<AuthUserModel> {
  SignupNotifier() : super(const AuthUserModel.empty());

  // Update individual fields
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  // Update multiple fields at once
  void updateUser(AuthUserModel user) {
    state = user;
  }

  // Reset state (useful after signup or on logout)
  void reset() {
    state = const AuthUserModel.empty();
  }

  // Validate current state
  bool validate() {
    return state.isValid && state.hasValidEmail && state.hasValidPassword;
  }
}
