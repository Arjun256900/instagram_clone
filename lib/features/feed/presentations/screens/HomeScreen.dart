import 'package:flutter/material.dart';
import 'package:instagram/features/feed/presentations/screens/FeedScreen.dart';
import 'package:instagram/user/presentations/screens/user_profile.dart';
import '../../../../core/constants/home_nav_constants.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Feedscreen(),
    Center(child: Text("Search")),
    Center(child: Text("Reels")),
    Center(child: Text("Shop")),
    UserProfile(),
  ];

  Widget _buildNavItem({
    required Map<String, String> iconMap,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Image.asset(
        index == 4
            ? 'assets/user_profile.png'
            : isSelected
            ? iconMap['selected']!
            : iconMap['unselected']!,
        height: index == 4 ? 55 : 63,
        width: index == 4 ? 55 : 63,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              iconMap: isDark ? homeIconMapDark : homeIconMapLight,
              index: 0,
            ),
            _buildNavItem(
              iconMap: isDark ? searchIconMapDark : searchIconMapLight,
              index: 1,
            ),
            _buildNavItem(
              iconMap: isDark ? addPostIconMapDark : addPostIconMapLight,
              index: 2,
            ),
            _buildNavItem(
              iconMap: isDark ? reelsIconMapDark : reelsIconMapLight,
              index: 3,
            ),
            _buildNavItem(
              iconMap: isDark ? profileIconMapDark : profileIconMapLight,
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
