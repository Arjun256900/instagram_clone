import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';

class HeroText extends StatelessWidget {
  final isDarkMode;
  final String text;
  final String subText;
  const HeroText({
    super.key,
    required this.isDarkMode,
    required this.subText,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 28,
            color: isDarkMode ? AppColors.darkSecondary : AppColors.secondary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subText,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? AppColors.darkSecondary : AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
