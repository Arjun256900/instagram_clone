import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';

class Emptyuserposts extends StatelessWidget {
  final String message;
  final String postType;
  const Emptyuserposts({
    super.key,
    required this.message,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.65),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: isDark ? AppColors.darkSecondary : AppColors.secondary,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                postType != "tagged"
                    ? "Create your first $postType"
                    : "When people tag you in photos and videos, they'll appear here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: postType != "tagged" ? Colors.blue : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
