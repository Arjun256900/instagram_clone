import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/user/presentations/screens/settings_activity.dart';
import 'package:instagram/features/user/presentations/widgets/profile_buttons.dart';
import 'package:instagram/features/user/presentations/widgets/user_posts.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget _buildStatItem(String count, String label, bool isDark) {
    return Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? AppColors.darkSecondary : AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkSecondary : AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Arjun',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkSecondary : AppColors.secondary,
          ),
        ),
        actions: [
          Image.asset(
            isDark
                ? 'assets/addpost_unselected_dark.png'
                : 'assets/addpost_unselected_light.png',
            fit: BoxFit.contain,
            height: 70,
            width: 70,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => SettingsActivity()),
              );
            },
            child: Image.asset(
              isDark
                  ? 'assets/profile_more_dark.png'
                  : 'assets/profile_more_light.png',
              fit: BoxFit.contain,
              height: 70,
              width: 70,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile pic
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcCX5ozV5a_bt2vsUealu1Y3Dam0gp2jqu_g&s',
                  ),
                  radius: 40,
                ),

                const SizedBox(width: 15),

                // Name + stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      Text(
                        'Arjun',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem('0', 'posts', isDark),
                          _buildStatItem('0', 'followers', isDark),
                          _buildStatItem('0', 'following', isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Follow buttons
            ProfileButtons(),
            const SizedBox(height: 25),
            Expanded(child: UserPosts()),
          ],
        ),
      ),
    );
  }
}
