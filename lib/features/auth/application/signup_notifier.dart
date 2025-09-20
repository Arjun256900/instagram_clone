import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/signup_user_model.dart';

class SignupNotifier extends StateNotifier<SignupUserModel> {
  SignupNotifier() : super(SignupUserModel());
  void setMobile(String mobile) {
    state = state.copyWith(mobile: mobile);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setDob(String dob) {
    state = state.copyWith(dob: dob);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setUsername(String userName) {
    state = state.copyWith(username: userName);
  }

  void setIsMobile(bool isMobile) {
    state = state.copyWith(isMobile: !isMobile);
  }

  void resetSignUpModel() {
    state = SignupUserModel();
  }
}
