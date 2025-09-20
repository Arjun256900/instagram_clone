import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/providers/signup_provider.dart';
import 'package:instagram/features/auth/presentation/widgets/already_have_account.dart';
import 'package:instagram/features/auth/presentation/screens/terms_and_policy_screen.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetUsernameScreen extends ConsumerStatefulWidget {
  const SetUsernameScreen({super.key});

  @override
  ConsumerState<SetUsernameScreen> createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends ConsumerState<SetUsernameScreen> {
  final usernameEditingController = TextEditingController();
  String? errorMessage;
  bool hasTriedToSubmit = false;

  void validateInput() {
    hasTriedToSubmit = true;
    final username = usernameEditingController.text.trim();
    if (username.isEmpty || username.length < 3) {
      setState(() {
        errorMessage = 'Username must be at least 3 characters long';
      });
      return;
    }
    setState(() {
      errorMessage = null;
    });
    ref.read(signupProvider.notifier).setUsername(username);
    debugPrint("Username : ${ref.watch(signupProvider).username}");
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => TermsAndPolicyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("")),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              HeroText(
                isDarkMode: isDarkMode,
                subText:
                    "Add a username or use our suggestion. You can change this at any time",
                text: "Create a username",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "Username",
                isPassword: false,
                textEditingController: usernameEditingController,
                isMobile: false,
                errorMessage: errorMessage,
              ),
              const SizedBox(height: 15),
              AuthButton(
                text: "Next",
                isEnabled: errorMessage == null,
                hasTriedToSubmit: hasTriedToSubmit,
                onPressed: validateInput,
              ),
              const Spacer(),
              AlreadyHaveAccount(num: 6),
            ],
          ),
        ),
      ),
    );
  }
}
