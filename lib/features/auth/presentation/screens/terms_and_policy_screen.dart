import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/screens/already_have_account.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';
import 'package:instagram/features/feed/presentations/screens/HomeScreen.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            HeroText(
              isDarkMode: isDarkMode,
              subText: "",
              text: "Agree to Instagram's terms and policies",
            ),
            const SizedBox(height: 15),
            Text(
              "People who use our service may haev uploaded your contact information to instagram.",
            ),
            const SizedBox(height: 15),
            Text(
              "By tapping I agree, you agree to create an account to instagram's Terms, Privacy Policyand Cookies Policy.",
            ),
            const SizedBox(height: 15),
            Text(
              "The Privacy Policy describes the ways we can use the information we collect when you create an account. For example, we use this information to provide, personalize and imporve our products, including ads",
            ),
            const SizedBox(height: 15),
            AuthButton(
              text: "I agree",
              isEnabled: true,
              hasTriedToSubmit: false,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
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
