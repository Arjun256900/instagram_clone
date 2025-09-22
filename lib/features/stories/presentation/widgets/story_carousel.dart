import 'package:flutter/material.dart';
import 'package:instagram/features/stories/presentation/widgets/story_item.dart';

class StoryCarousel extends StatefulWidget {
  const StoryCarousel({super.key});

  @override
  State<StoryCarousel> createState() => _StoryCarouselState();
}

class _StoryCarouselState extends State<StoryCarousel> {
  // (Dummy stories list and gradient remain the same)
  final List<Map<String, dynamic>> _stories = [
    {
      'id': 'you',
      'name': 'Your story',
      'avatar': 'https://i.pravatar.cc/200?img=5',
      'isNew': false,
      'isYou': true,
    },
    {
      'id': '1',
      'name': 'runwaylayla',
      'avatar': 'https://i.pravatar.cc/200?img=11',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '2',
      'name': 'prince_of_wale',
      'avatar': 'https://i.pravatar.cc/200?img=12',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '3',
      'name': '_bha._.rat',
      'avatar': 'https://i.pravatar.cc/200?img=13',
      'isNew': false,
      'isYou': false,
    },
    {
      'id': '4',
      'name': 'wanderer',
      'avatar': 'https://i.pravatar.cc/200?img=14',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '5',
      'name': 'tech_savvy',
      'avatar': 'https://i.pravatar.cc/200?img=15',
      'isNew': false,
      'isYou': false,
    },
    {
      'id': '6',
      'name': 'art_by_mia',
      'avatar': 'https://i.pravatar.cc/200?img=16',
      'isNew': true,
      'isYou': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        // gap between stories
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _stories[index];
          final bool isYou = item['isYou'] == true;

          return StoryItem(isYou: isYou, storyItem: item);
        },
      ),
    );
  }
}
