import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/screens/already_have_account.dart';
import 'package:instagram/features/auth/presentation/screens/set_password.dart';
import 'dart:ui';

import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final mobileEmailController = TextEditingController();
  var isMobile = true;
  bool isLoading = false;
  String? errorMessage;
  bool hasTriedToSignUp = false;
  // Regex for validation
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  final RegExp phoneRegex = RegExp(r"^[0-9]{10}$");

  @override
  void dispose() {
    mobileEmailController.dispose();
    super.dispose();
  }

  void validateInput() {
    hasTriedToSignUp = true;
    String input = mobileEmailController.text;
    if (isMobile) {
      if (!phoneRegex.hasMatch(input)) {
        setState(() {
          errorMessage =
              "Looks like your mobile number may be incorrect. Try entering your full number";
        });
        return;
      }
      setState(() {
        errorMessage = null;
      });
    } else {
      if (!emailRegex.hasMatch(input)) {
        setState(() {
          errorMessage =
              "Looks like your email may be incorrect. Try entering your full and valid email address";
        });
        return;
      }
      setState(() {
        errorMessage = null;
      });
    }
    setState(() {
      errorMessage = null;
    });
    print("Successfully validated the input : $input");
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SetPassword(isMobile: isMobile)),
    );
  }

  void toggleSignupMethod() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    ); // Simulate loading delay

    setState(() {
      isMobile = !isMobile;
      isLoading = false;
      mobileEmailController.text = "";
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text("")),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    HeroText(
                      isDarkMode: isDarkMode,
                      text:
                          "What's your ${isMobile ? "mobile number?" : "email address?"}",
                      subText:
                          "Enter the ${isMobile ? "mobile number" : "email address"} on which you can be contacted. No one will see this on your profile",
                    ),
                    const SizedBox(height: 28),

                    // Input Field
                    CustomTextField(
                      textEditingController: mobileEmailController,
                      hintText: isMobile ? "Mobile number" : "Email address",
                      isPassword: false,
                      isMobile: isMobile,
                      errorMessage: errorMessage,
                    ),
                    const SizedBox(height: 15),

                    Text(
                      "You may receive ${isMobile ? "WhatsApp and SMS" : "email"} notifications from us for security and login purposes",
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(height: 20),

                    AuthButton(
                      text: "Next",
                      onPressed: validateInput,
                      isEnabled: errorMessage == null,
                      hasTriedToSubmit: hasTriedToSignUp,
                    ),
                    const SizedBox(height: 17),

                    // Sign up with email button
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: toggleSignupMethod,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        child: Text(
                          isMobile
                              ? "Sign up with email address"
                              : "Sign up with mobile number",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    AlreadyHaveAccount(num: 1),
                  ],
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
                child: Container(
                  color: Colors.black38.withOpacity(0.3), // Dim background
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
