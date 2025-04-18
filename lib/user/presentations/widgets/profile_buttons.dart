import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';

class ProfileButtons extends StatefulWidget {
  const ProfileButtons({super.key});

  @override
  State<ProfileButtons> createState() => _ProfileButtonsState();
}

class _ProfileButtonsState extends State<ProfileButtons> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              shadowColor: Colors.transparent,
              overlayColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isDark ? Colors.white : Colors.black),
              ),
            ),
            child: Text(
              'Edit profile',
              style: TextStyle(
                color: isDark ? AppColors.darkSecondary : AppColors.secondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              shadowColor: Colors.transparent,
              overlayColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isDark ? Colors.white : Colors.black),
              ),
            ),
            child: Text(
              'Share profile',
              style: TextStyle(
                color: isDark ? AppColors.darkSecondary : AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
