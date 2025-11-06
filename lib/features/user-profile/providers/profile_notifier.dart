import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_user_model.dart';

class ProfileNotifier extends StateNotifier<ProfileUserModel> {
  ProfileNotifier() : super(const ProfileUserModel.empty());

  // Update individual fields
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  // Update multiple fields at once
  void updateUser(ProfileUserModel user) {
    state = user;
  }

  // Reset state (useful after signup or on logout)
  void reset() {
    state = const ProfileUserModel.empty();
  }
}
