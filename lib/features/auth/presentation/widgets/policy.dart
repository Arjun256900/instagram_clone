import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';

class Policy extends StatelessWidget {
  const Policy({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
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
      ],
    );
  }
}
