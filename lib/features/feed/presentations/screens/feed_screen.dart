// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/features/dm/presentation/screens/dm_screen.dart';
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
      // The NestedScrollView coordinates scrolling between the app bar and the body
      body: NestedScrollView(
        // The headerSliverBuilder builds the app bar part
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title:
                  isDark
                      ? Image.asset('assets/ig_logo_dark.png', height: 45)
                      : SvgPicture.asset(
                        'assets/ig_logo_light.svg',
                        height: 45,
                      ),
              // This makes the app bar disappear when scroll up
              floating: true,
              // This makes the app bar reappear when scroll down
              snap: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.heart, size: 25),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => DmScreen()),
                    );
                  },  
                  icon: const Icon(
                    FontAwesomeIcons.facebookMessenger,
                    size: 25,
                  ),
                ),
              ],
            ),
          ];
        },
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Story widget
                const Stories(),
                // Post widget
                const Post(
                  media: [
                    {
                      'type': 'image',
                      'url':
                          "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?cs=srgb&dl=pexels-pixabay-206359.jpg&fm=jpg",
                    },
                    {
                      'type': 'image',
                      'url':
                          'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1180&q=80',
                    },
                    {
                      'type': 'video',
                      'url':
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                    },
                    {
                      'type': 'image',
                      'url':
                          'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg?auto=compress&cs=tinysrgb&w=1200',
                    },
                  ],
                ),
                const Post(
                  media: [
                    {
                      'type': 'image',
                      'url':
                          'https://images.pexels.com/photos/11930775/pexels-photo-11930775.jpeg?auto=compress&cs=tinysrgb&w=1200',
                    },
                    {
                      'type': 'image',
                      'url':
                          'https://images.pexels.com/photos/11621973/pexels-photo-11621973.jpeg?auto=compress&cs=tinysrgb&w=1200',
                    },
                  ],
                ),
                // const Post(
                //   media: [
                //     {
                //       'type': 'video',
                //       'url':
                //           'https://www.pexels.com/video/woman-posing-while-a-man-is-sketching-3804812/',
                //     },
                //   ],
                // ),
                const Post(
                  media: [
                    {
                      'type': 'image',
                      'url':
                          'https://images.pexels.com/photos/11621973/pexels-photo-11621973.jpeg?auto=compress&cs=tinysrgb&w=1200',
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
