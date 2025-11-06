import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_user_model.dart';

class ProfileNotifier extends StateNotifier<ProfileUserModel> {
  ProfileNotifier() : super(const ProfileUserModel.empty());

  void setUid(String uid) {
    state = state.copyWith(uid: uid);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  void setDob(String dob) {
    state = state.copyWith(dob: dob);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setPrivacy(bool isPrivate) {
    state = state.copyWith(isPrivate: isPrivate);
  }

  void updateProfile(ProfileUserModel profile) {
    state = profile;
  }

  void reset() {
    state = const ProfileUserModel.empty();
  }
}

// Provider definition
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileUserModel>((ref) {
      return ProfileNotifier();
    });
