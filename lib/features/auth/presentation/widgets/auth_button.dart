import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool hasTriedToSubmit;
  final bool? isLoading;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.isEnabled,
    required this.hasTriedToSubmit,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isEnabled
                ? onPressed
                : hasTriedToSubmit
                ? onPressed
                : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child:
            isLoading == true
                ? SizedBox(
                  height: 23.5,
                  width: 23.5,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
