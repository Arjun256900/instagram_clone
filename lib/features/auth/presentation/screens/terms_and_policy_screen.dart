import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/providers/signup_provider.dart';
import 'package:instagram/features/auth/presentation/widgets/already_have_account.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/policy.dart';
import 'package:instagram/features/feed/presentations/screens/HomeScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/utils/token_storage.dart';

// This screen is where the signup request is made, if the user clicks agree

class TermsAndPolicyScreen extends ConsumerStatefulWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  ConsumerState<TermsAndPolicyScreen> createState() =>
      _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends ConsumerState<TermsAndPolicyScreen> {
  bool isLoading = false;
  final _tokenStorage = TokenStorage();

  void validateInput() async {
    setState(() {
      isLoading = true;
    });
    final signupData = ref.watch(signupProvider);
    final url = Uri.http('10.0.2.2', '/auth/signup');
    final body = {
      'username': signupData.username,
      'name': signupData.name,
      'dob': signupData.dob,
      'password': signupData.password,
      'isMobile': signupData.isMobile,
    };
    if (signupData.isMobile! == true) {
      body['mobile'] = signupData.mobile;
    }
    if (signupData.isMobile! == false) {
      body['email'] = signupData.email;
    }
    try {
      final result = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print("Status: ${result.statusCode}");
      print("Body: ${result.body}");

      if (result.statusCode == 201) {
        // parse tokens
        final data = jsonDecode(result.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        print("Sign up successful");
        print("AccessToken : $accessToken");
        print("RefreshToken : $refreshToken");
        setState(() {
          isLoading = false;
        });
        // Store tokens
        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => Homescreen()),
        );
      } else {
        final error = jsonDecode(result.body);
        // Show error to user (snackbar / dialog / setState)
        print("Signup failed: ${error['message'] ?? error['errors']}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error signing up: $e");
      // Optionally show a generic “something went wrong” UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Policy(),
            AuthButton(
              text: "I agree",
              isLoading: isLoading,
              isEnabled: true,
              hasTriedToSubmit: false,
              onPressed: validateInput,
            ),
            const Spacer(),
            AlreadyHaveAccount(num: 7),
          ],
        ),
      ),
    );
  }
}
