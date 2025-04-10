import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("Home", style: TextStyle(fontSize: 24))),
    Center(child: Text("Search", style: TextStyle(fontSize: 24))),
    Center(child: Text("Reels", style: TextStyle(fontSize: 24))),
    Center(child: Text("Shop", style: TextStyle(fontSize: 24))),
    Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],

      // 🍑 Custom Bottom Nav Bar
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home_outlined, index: 0),
            _buildNavItem(icon: Icons.search, index: 1),
            _buildNavItem(icon: Icons.video_library_outlined, index: 2),
            _buildNavItem(icon: Icons.shopping_bag_outlined, index: 3),
            _buildNavItem(icon: Icons.account_circle_outlined, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque, // Ensures the whole area is tappable
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Colors.white : Colors.white54,
      ),
    );
  }
}
