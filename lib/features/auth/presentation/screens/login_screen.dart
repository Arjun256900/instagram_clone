// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/auth/presentation/screens/signup_screen.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/custom_text_field.dart';
// import 'package:http/http.dart' as http;
import 'package:instagram/features/auth/presentation/widgets/general_error.dart';
import 'package:instagram/features/feed/presentations/screens/HomeScreen.dart';
// import 'package:instagram/features/feed/presentations/screens/HomeScreen.dart';
// import '../../../../core/utils/token_storage.dart';

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
  var isLoading = false;
  var isLoginGeneralError = false;
  String? loginGeneralError;
  // final _tokenStorage = TokenStorage();

  void validateInput() async {
    setState(() {
      isLoading = !isLoading;
    });
    hasTriedToLogin = true;
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();
    if (userName.length >= 3 && password.length >= 8) {
      setState(() {
        userNameErrorMessage = null;
        passwordErrorMessage = null;
      });
      // Call API to login with provided credentials.
      // final url = Uri.http(
      //   '10.0.2.2',
      //   '/auth/login',
      // ); // 10.0.2.2 for androind emulators
      // final body = {'username': userName, 'password': password};

      // try {
      //   final result = await http.post(
      //     url,
      //     headers: {"Content-type": "application/json"},
      //     body: jsonEncode(body),
      //   );
      //   print("Status: ${result.statusCode}");
      //   print("Body: ${result.body}");
      //   if (result.statusCode == 200) {
      //     final data = jsonDecode(result.body);
      //     final authToken = data['accessToken'];
      //     final refreshToken = data['refreshToken'];
      //     // Store tokens
      //     await _tokenStorage.saveTokens(
      //       accessToken: authToken,
      //       refreshToken: refreshToken,
      //     );
      //     Navigator.push(
      //       context,
      //       CupertinoPageRoute(builder: (context) => Homescreen()),
      //     );
      //   } else {
      //     final error = jsonDecode(result.body);
      //     setState(() {
      //       isLoginGeneralError = true;
      //       loginGeneralError = error['message'];
      //     });
      //     print("Login failed: ${error['message']}");
      //   }
      // } catch (e) {
      //   print("Error occurred while logging in: $e");
      // }
      Navigator.of(
        context,
      ).pushReplacement(CupertinoPageRoute(builder: (context) => Homescreen()));
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
        isLoading = !isLoading;
      });
      return;
    }
    print("User name: " + userName + "password: " + password);
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // ensure resizing when keyboard appears (default is true)
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // make sure keyboard pushes content and we have bottom padding
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Expand the center area to take available space
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              isDarkMode
                                  ? "assets/ig_logo_dark.png"
                                  : "assets/ig_logo_light.png",
                              height: 64,
                            ),
                            const SizedBox(height: 32),
                            CustomTextField(
                              textEditingController: userNameController,
                              hintText: "Phone number, username or email",
                              isPassword: false,
                              errorMessage: userNameErrorMessage,
                              isMobile: false,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              textEditingController: passwordController,
                              hintText: "Password",
                              isPassword: true,
                              errorMessage: passwordErrorMessage,
                              isMobile: false,
                            ),
                            const SizedBox(height: 16),
                            Visibility(
                              visible:
                                  isLoginGeneralError &&
                                  loginGeneralError != null,
                              child: GeneralError(
                                error: loginGeneralError ?? '',
                              ),
                            ),
                            const SizedBox(height: 16),
                            AuthButton(
                              text: "Log in",
                              onPressed: isLoading ? () {} : validateInput,
                              isLoading: isLoading,
                              isEnabled:
                                  (userNameErrorMessage == null &&
                                      passwordErrorMessage == null),
                              hasTriedToSubmit: hasTriedToLogin,
                            ),
                            const SizedBox(height: 16),
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

                      // Bottom create-account button (always pushed to bottom)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed:
                              isLoading
                                  ? () {}
                                  : () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
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
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
