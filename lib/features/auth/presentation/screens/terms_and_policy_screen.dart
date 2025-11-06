import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/widgets/already_have_account.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/features/auth/providers/auth_provider.dart';
import 'package:instagram/features/feed/presentation/screens/home_screen.dart';
import 'package:instagram/features/user-profile/providers/profile_provider.dart';
// import '../../../../core/utils/token_storage.dart';

// This screen is where the signup request is made, if the user clicks agree

class TermsAndPolicyScreen extends ConsumerStatefulWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  ConsumerState<TermsAndPolicyScreen> createState() =>
      _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends ConsumerState<TermsAndPolicyScreen> {
  bool isLoading = false;
  // final _tokenStorage = TokenStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Policy(),
            AuthButton(
              text: "I agree",
              isLoading: isLoading,
              isEnabled: true,
              hasTriedToSubmit: false,
              onPressed: () {
                debugPrint(ref.read(signupProvider).toJson().toString());
                debugPrint(ref.read(profileProvider).toJson().toString());
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (context) => Homescreen()),
                );
              },
            ),
            const Spacer(),
            AlreadyHaveAccount(num: 7),
          ],
        ),
      ),
    );
  }
}
