import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/auth/presentation/screens/signup_screen.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String? userNameErrorMessage;
  String? passwordErrorMessage;
  bool hasTriedToLogin = false;

  void validateInput() {
    hasTriedToLogin = true;
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();
    if (userName.length >= 3 && password.length >= 8) {
      setState(() {
        userNameErrorMessage = null;
        passwordErrorMessage = null;
      });
      //TODO  LOGIN LOGIC
    } else {
      setState(() {
        userNameErrorMessage =
            userName.length < 3
                ? "Username must be at least 3 characters"
                : null;
        passwordErrorMessage =
            password.length < 8
                ? "Password must be at least 8 characters"
                : null;
      });
      return;
    }
    print("User name: " + userName + "password: " + password);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              // Expanded to center the login fields
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      isDarkMode
                          ? "assets/ig_logo_dark.png"
                          : "assets/ig_logo_light.png",
                      height: 64,
                    ),
                    const SizedBox(height: 32),

                    // Username / Email input
                    CustomTextField(
                      textEditingController: userNameController,
                      hintText: "Phone number, username or email",
                      isPassword: false,
                      errorMessage: userNameErrorMessage,
                      isMobile: false,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    CustomTextField(
                      textEditingController: passwordController,
                      hintText: "Password",
                      isPassword: true,
                      errorMessage: passwordErrorMessage,
                      isMobile: false,
                    ),
                    const SizedBox(height: 16),

                    // Login Button
                    AuthButton(
                      text: "Log in",
                      onPressed: validateInput,
                      isEnabled:
                          (userNameErrorMessage == null &&
                              passwordErrorMessage == null),
                      hasTriedToSubmit: hasTriedToLogin,
                    ),
                    const SizedBox(height: 16),

                    // Forgot password
                    Text(
                      "Forgotten Password?",
                      style: TextStyle(
                        color:
                            isDarkMode
                                ? AppColors.darkSecondary
                                : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Create New Account Button at the Bottom
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.darkAccent),
                  ),
                  child: Text(
                    "Create a new account",
                    style: TextStyle(color: AppColors.darkAccent),
                  ),
                ),
              ),
              const SizedBox(height: 25), // Add some spacing at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
