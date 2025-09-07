import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/features/feed/presentations/widgets/post.dart';
import 'package:instagram/features/feed/presentations/widgets/stories.dart';

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
        title:
            isDark
                ? Image.asset('assets/ig_logo_dark.png', height: 45)
                : SvgPicture.asset('assets/ig_logo_light.svg', height: 45),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.heart, size: 30),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.message, size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Story widget
              Stories(),
              // Post widget
              Post(),
            ],
          ),
        ),
      ),
    );
  }
}
