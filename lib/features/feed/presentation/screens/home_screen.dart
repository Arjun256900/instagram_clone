import 'package:flutter/material.dart';
import 'package:instagram/features/feed/presentation/screens/feed_screen.dart';
import 'package:instagram/features/reels/presentations/screens/reel_screen.dart';
import 'package:instagram/features/user/presentation/screens/user_profile.dart';
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
    Center(child: Text("Add post")),
    ReelScreen(),
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
    final bool isNavBarDark = isDark || _selectedIndex == 3;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: isNavBarDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              iconMap: isNavBarDark ? homeIconMapDark : homeIconMapLight,
              index: 0,
            ),
            _buildNavItem(
              iconMap: isNavBarDark ? searchIconMapDark : searchIconMapLight,
              index: 1,
            ),
            _buildNavItem(
              iconMap: isNavBarDark ? addPostIconMapDark : addPostIconMapLight,
              index: 2,
            ),
            _buildNavItem(
              iconMap: isNavBarDark ? reelsIconMapDark : reelsIconMapLight,
              index: 3,
            ),
            _buildNavItem(
              iconMap: isNavBarDark ? profileIconMapDark : profileIconMapLight,
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
