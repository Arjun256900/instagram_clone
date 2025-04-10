import 'package:instagram/features/auth/data/models/signup_user_model.dart';

import '../../application/signup_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupProvider = StateNotifierProvider<SignupNotifier, SignupUserModel>(
  (ref) => SignupNotifier(),
);
