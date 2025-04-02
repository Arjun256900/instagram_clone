import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/screens/already_have_account.dart';
import 'package:instagram/features/auth/presentation/screens/date_of_birth.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';

class SetPassword extends StatefulWidget {
  final bool isMobile;
  const SetPassword({super.key, required this.isMobile});

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final passwordEditingController = TextEditingController();
  String? errorMessage;
  bool hasTriedToSetPassword = false;

  void validateInput() {
    hasTriedToSetPassword = true;
    if (passwordEditingController.text.isEmpty ||
        passwordEditingController.text.length < 6) {
      setState(() {
        errorMessage =
            "This password is too short. Create a longer password with at least six letters and numbers";
      });
      return;
    }
    setState(() {
      errorMessage = null;
    });
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DateOfBirth()),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeroText(
                isDarkMode: isDarkMode,
                subText:
                    "Create a password with at least six letters or numbers. It should be something that others can't guess",
                text: "Create a password",
              ),
              const SizedBox(height: 28),
              // Input Field
              CustomTextField(
                textEditingController: passwordEditingController,
                hintText: "Password",
                isPassword: true,
                isMobile: false,
                errorMessage: errorMessage,
              ),
              const SizedBox(height: 12),

              AuthButton(
                text: "Next",
                onPressed: validateInput,
                isEnabled: errorMessage == null,
                hasTriedToSubmit: hasTriedToSetPassword,
              ),
              const SizedBox(height: 17),
              const Spacer(),
              AlreadyHaveAccount(num: 2),
            ],
          ),
        ),
      ),
    );
  }
}
