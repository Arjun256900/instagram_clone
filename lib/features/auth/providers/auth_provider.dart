import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user_model.dart';
import 'auth_notifier.dart';

// Signup state provider
final signupProvider = StateNotifierProvider<SignupNotifier, AuthUserModel>((
  ref,
) {
  return SignupNotifier();
});

// Current signup data selector (for easy access)
final currentSignupDataProvider = Provider<AuthUserModel>((ref) {
  return ref.watch(signupProvider);
});

// Validation provider
final isSignupValidProvider = Provider<bool>((ref) {
  final user = ref.watch(signupProvider);
  return user.isValid && user.hasValidEmail && user.hasValidPassword;
});

// Individual field providers (useful for form field validation)
final signupEmailProvider = Provider<String>((ref) {
  return ref.watch(signupProvider).email;
});

final signupPasswordProvider = Provider<String>((ref) {
  return ref.watch(signupProvider).password;
});

final signupUsernameProvider = Provider<String>((ref) {
  return ref.watch(signupProvider).username;
});
