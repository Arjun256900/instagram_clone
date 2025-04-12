import 'package:flutter/material.dart';

class Feedscreen extends StatefulWidget {
  const Feedscreen({super.key});

  @override
  State<Feedscreen> createState() => _FeedscreenState();
}

class _FeedscreenState extends State<Feedscreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          height: 54,
          isDark ? 'assets/ig_logo_dark.png' : 'assets/ig_logo_light.png',
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
          Image.asset(isDark ? 'assets/dm_dark.png' : 'assets/dm_light.png'),
        ],
      ),
    );
  }
}
