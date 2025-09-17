// ignore_for_file: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class DmNotes extends StatefulWidget {
  const DmNotes({super.key});

  @override
  State<DmNotes> createState() => _DmNotesState();
}

class _DmNotesState extends State<DmNotes> {
  final List<Map<String, dynamic>> _DmNotes = [
    {
      'id': 'you',
      'name': 'Your notes',
      'avatar': 'https://i.pravatar.cc/200?img=5',
      'isNew': false,
      'isYou': true,
      'marquee': ['Song: Ruhe', 'Composer: LOTTE', 'Chill vibes only'],
    },
    {
      'id': '1',
      'name': 'runwaylayla',
      'avatar': 'https://i.pravatar.cc/200?img=11',
      'isNew': true,
      'isYou': false,
      'marquee': ['Inayae', 'Sid Sriram', '✨'],
    },
    {
      'id': '2',
      'name': 'prince_of_wale',
      'avatar': 'https://i.pravatar.cc/200?img=12',
      'isNew': true,
      'isYou': false,
      'marquee': ['Song: Ruhe', 'Composer: LOTTE', 'Chill vibes only'],
    },
    {
      'id': '3',
      'name': '_bha._.rat',
      'avatar': 'https://i.pravatar.cc/200?img=13',
      'isNew': false,
      'isYou': false,
      'marquee': ['Maula Me..', 'Sonu World', '👀🔥'],
    },
    {
      'id': '4',
      'name': 'wanderer',
      'avatar': 'https://i.pravatar.cc/200?img=14',
      'isNew': true,
      'isYou': false,
      'marquee': ['Inayae', 'Sid Sriram', '✨'],
    },
    {
      'id': '5',
      'name': 'tech_savvy',
      'avatar': 'https://i.pravatar.cc/200?img=15',
      'isNew': false,
      'isYou': false,
      'marquee': ['Inayae', 'Sid Sriram', '✨'],
    },
    {
      'id': '6',
      'name': 'art_by_mia',
      'avatar': 'https://i.pravatar.cc/200?img=16',
      'isNew': true,
      'isYou': false,
      'marquee': ['Inayae', 'Sid Sriram', '✨'],
    },
  ];

  Widget _buildNotesAvatar(
    Map<String, dynamic> notes, {
    required bool isDarkMode,
  }) {
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    Widget avatar = CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(notes['avatar']),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
    );

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: scaffoldBgColor),
      child: Padding(padding: const EdgeInsets.all(3.0), child: avatar),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _DmNotes.length,
        clipBehavior: Clip.none,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final item = _DmNotes[index];
          final marquee = List<String>.from(item['marquee'] ?? <String>[]);
          // final bool isYou = item['isYou'] == true;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 83,
                width: 83,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    // main avatar
                    _buildNotesAvatar(item, isDarkMode: isDarkMode),

                    // Song details bubble (positioned above avatar)
                    if (marquee.isNotEmpty)
                      Positioned(
                        top: -32.5,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 92,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode ? Colors.grey[900] : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Row: static animated-eq icon + marquee song title
                                SizedBox(
                                  height: 18,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Static-positioned animated 3-bar music icon (not part of marquee)
                                      StaticEqualizer(
                                        barColor:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                        barWidth: 3,
                                        barSpacing: 3,
                                        height: 12,
                                      ),
                                      const SizedBox(width: 6),

                                      // Marquee for song title
                                      Expanded(
                                        child: SizedBox(
                                          height: 18,
                                          child: Marquee(
                                            text: marquee[0],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isDarkMode
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                            velocity: 30.0,
                                            blankSpace: 24.0,
                                            pauseAfterRound: const Duration(
                                              milliseconds: 500,
                                            ),
                                            startPadding: 4.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 2),

                                // Singer / composer (single-line with ellipsis)
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    marquee.length > 1 ? marquee[1] : '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          (isDarkMode
                                              ? Colors.white70
                                              : Colors.black54),
                                    ),
                                  ),
                                ),

                                // Optional caption (third item)
                                if (marquee.length > 2 &&
                                    (marquee[2]).trim().isNotEmpty)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      marquee[2],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            (isDarkMode
                                                ? Colors.white60
                                                : Colors.black45),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // username label below avatar
              SizedBox(
                width: 80,
                child: Text(
                  item['name'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A small animated 3-bar equalizer widget. It animates bar heights (vertical)
/// but stays in a fixed position — perfect for the "music icon" in your bubble.
class StaticEqualizer extends StatefulWidget {
  final Color barColor;
  final double barWidth;
  final double barSpacing;
  final double height;

  const StaticEqualizer({
    super.key,
    required this.barColor,
    this.barWidth = 3,
    this.barSpacing = 3,
    this.height = 10,
  });

  @override
  State<StaticEqualizer> createState() => _StaticEqualizerState();
}

class _StaticEqualizerState extends State<StaticEqualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _barHeightFactor(int index, double t) {
    // create three staggered pseudo-random heights using sin waves
    final phase = index * 0.9;
    final val = 0.5 + 0.5 * math.sin((t * 2 * math.pi) + phase);
    // clamp to [0.4, 1.0] so bars never disappear
    return 0.4 + (val * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final factor = _barHeightFactor(i, t);
              final h = widget.height * factor;
              return Padding(
                padding: EdgeInsets.only(right: i == 2 ? 0 : widget.barSpacing),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: widget.barWidth,
                    height: h,
                    decoration: BoxDecoration(
                      color: widget.barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
