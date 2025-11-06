import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/widgets/already_have_account.dart';
import 'package:instagram/features/auth/presentation/screens/set_username_screen.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/features/user-profile/providers/profile_provider.dart';

class SetNameScreen extends ConsumerStatefulWidget {
  const SetNameScreen({super.key});

  @override
  ConsumerState<SetNameScreen> createState() => _SetNameScreenState();
}

class _SetNameScreenState extends ConsumerState<SetNameScreen> {
  final nameEditingController = TextEditingController();
  String? errorMessage;
  bool hasTriedToSubmit = false;

  void validateInput() {
    hasTriedToSubmit = true;
    final name = nameEditingController.text.trim();
    if (name.isEmpty || name.length < 2) {
      setState(() {
        errorMessage = 'Your name must be of at least two letters long';
      });
      return;
    }
    setState(() {
      errorMessage = null;
    });
    ref.read(profileProvider.notifier).setName(name);
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SetUsernameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroText(
                isDarkMode: isDarkMode,
                subText: "",
                text: "What's your name?",
              ),
              SizedBox(height: 16),
              CustomTextField(
                hintText: "Full name",
                isPassword: false,
                textEditingController: nameEditingController,
                isMobile: false,
                errorMessage: errorMessage,
              ),
              const SizedBox(height: 15),
              AuthButton(
                text: "Next",
                onPressed: validateInput,
                isEnabled: errorMessage == null,
                hasTriedToSubmit: hasTriedToSubmit,
              ),
              const Spacer(),
              AlreadyHaveAccount(num: 5),
            ],
          ),
        ),
      ),
    );
  }
}
