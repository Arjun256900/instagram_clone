import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/reels/presentations/screens/new_group_screen.dart';
import 'package:instagram/features/comments/presentations/screens/comment_modal.dart';
import 'package:instagram/features/reels/presentations/widgets/more_option.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:marquee/marquee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final PageController _pageController = PageController();

  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
  ];

  final List<String> _captions = [
    'Flutter animations are so smooth! 🦋 #flutterdev #uiux',
    'This is a much longer caption designed to demonstrate the "see more" functionality. When you tap on it, it will expand to show the full text in a beautiful, blurred overlay, just like you see on Instagram. #longcaption #uidesign',
    'Riding into the weekend! 🏍️ #adventure',
  ];

  final List<String> _musicNames = [
    'Original Sound - flutterdev',
    'Big Buck Bunny Theme - Sintel',
    'Joyride - Google TV',
  ];

  final List<String> _usernames = ['@flutterdev', '@blender', '@google'];

  final List<VideoPlayerController> _videoControllers = [];
  final List<ChewieController> _chewieControllers = [];
  final List<bool> _isCaptionExpanded = [];
  final List<bool> _isVideoInitialized = [];

  // state variables for double tap like
  final List<bool> _isLiked = [];
  final List<bool> _showHeartAnimation = [];
  final List<Offset> _doubleTapPositions = [];
  final List<int> _currentGradientIndexes = [];
  // state variable to store the random rotation for the heart (liking)
  final List<double> _heartRotations = [];

  // for mute/unmute
  bool _isMuted = false;
  bool _showMuteAnimation = false;
  int? _muteAnimationIndex; // to show mute animation only on current reel

  // animated like button gradients
  final List<LinearGradient> _heartGradients = [
    const LinearGradient(
      colors: [Color(0xFFd6249f), Color(0xFFfd5949), Color(0xFFfdf497)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF5851DB), Color(0xFF833AB4), Color(0xFFE1306C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF405DE6), Color(0xFF5B51D8), Color(0xFF833AB4)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    const LinearGradient(
      colors: [Color(0xFFfeda75), Color(0xFFfef07e), Color(0xFFc13584)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _isCaptionExpanded.addAll(List.generate(_videoUrls.length, (_) => false));
    _isVideoInitialized.addAll(List.generate(_videoUrls.length, (_) => false));

    _isLiked.addAll(List.generate(_videoUrls.length, (_) => false));
    _showHeartAnimation.addAll(List.generate(_videoUrls.length, (_) => false));
    _doubleTapPositions.addAll(
      List.generate(_videoUrls.length, (_) => Offset.zero),
    );
    _currentGradientIndexes.addAll(List.generate(_videoUrls.length, (_) => 0));
    // --- NEW: Initialize rotation list ---
    _heartRotations.addAll(List.generate(_videoUrls.length, (_) => 0.0));
    // -------------------------------------

    _initializePage(0);

    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (newPage != _currentPage) {
        if (_currentPage < _chewieControllers.length) {
          _chewieControllers[_currentPage].pause();
        }
        _currentPage = newPage;
        _initializePage(_currentPage);
      }
    });
  }

  Future<void> _initializePage(int index) async {
    if (index < _videoControllers.length) {
      await _chewieControllers[index].play();
      setState(() {
        _isVideoInitialized[index] = true;
      });
      return;
    }

    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(_videoUrls[index]),
    );
    await videoController.initialize();
    await videoController.setVolume(_isMuted ? 0.0 : 1.0);

    final chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: true,
      showControls: false,
      aspectRatio: videoController.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Text(
            'Error: Could not load video.',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() {
      if (index >= _videoControllers.length) {
        _videoControllers.add(videoController);
        _chewieControllers.add(chewieController);
      } else {
        _videoControllers[index] = videoController;
        _chewieControllers[index] = chewieController;
      }
      _isVideoInitialized[index] = true;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    // Update volume for all initialized controllers (i.e all reels which the user has loaded before)
    for (var controller in _videoControllers) {
      controller.setVolume(_isMuted ? 0.0 : 1.0);
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  // mute animation on tap
  void _triggerMuteAnimation(int index) {
    setState(() {
      _showMuteAnimation = true;
      _muteAnimationIndex = index;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showMuteAnimation = false;
        });
      }
    });
  }

  // Widget for the mute icon animation at the center
  Widget _buildMuteAnimation() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: _showMuteAnimation ? 1.0 : 0.0,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: _showMuteAnimation ? 1.0 : 0.7),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  // like on double tap
  void _triggerLikeAnimation(int index, {Offset? tapPosition}) {
    setState(() {
      _showHeartAnimation[index] = true;
      _isLiked[index] = true;
      _doubleTapPositions[index] =
          tapPosition ??
          Offset(
            MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.height / 2,
          );
      _currentGradientIndexes[index] = Random().nextInt(_heartGradients.length);
      // Decide randomly whether to tilt the heart (0.4 radians ~ 23 degrees) or not
      _heartRotations[index] = Random().nextBool() ? 0.4 : 0.0;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showHeartAnimation[index] = false;
        });
      }
    });
  }

  void _showCommentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const CommentModal();
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
    Color? bg,
  }) {
    final color =
        bg != null ? Colors.white : (isDarkMode ? Colors.white : Colors.black);
    final backgroundColor =
        bg ?? (isDarkMode ? Colors.grey[800] : Colors.grey[200]);

    return SizedBox(
      width: 80,
      height: 110, // Fixed height ensures consistent alignment
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed size container for the icon
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          // Text with fixed height to ensure consistent spacing
          SizedBox(
            height: 32, // Fixed height for text area
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12,
                height: 1.2, // Improves text alignment for multi-line text
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context) {
    final sheetController = DraggableScrollableController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          controller: sheetController,
          initialChildSize: 0.65,
          minChildSize: 0.55,
          maxChildSize: 0.97,
          expand: false,
          builder: (context, scrollController) {
            // (dummy contacts list remains the same)
            final contacts = [
              {
                "name": "Unsuccessful abortions.",
                "avatar": "https://i.pravatar.cc/150?img=10",
              },
              {"name": "Eshwar", "avatar": "https://i.pravatar.cc/150?img=11"},
              {"name": "deepu⭐", "avatar": "https://i.pravatar.cc/150?img=12"},
              {
                "name": "Harish J",
                "avatar": "https://i.pravatar.cc/150?img=13",
              },
              {"name": "Anu", "avatar": "https://i.pravatar.cc/150?img=14"},
              {"name": "Lindane", "avatar": "https://i.pravatar.cc/150?img=15"},
              {"name": "Maya", "avatar": "https://i.pravatar.cc/150?img=16"},
              {"name": "Ravi", "avatar": "https://i.pravatar.cc/150?img=17"},
              {"name": "Sita", "avatar": "https://i.pravatar.cc/150?img=18"},
              {"name": "Vikram", "avatar": "https://i.pravatar.cc/150?img=19"},
              {"name": "Nisha", "avatar": "https://i.pravatar.cc/150?img=20"},
              {"name": "Arjun", "avatar": "https://i.pravatar.cc/150?img=21"},
            ];

            // (scroll listener logic remains the same)
            double previousOffset = 0;
            scrollController.addListener(() {
              if (!scrollController.hasClients) return;
              final offset = scrollController.offset;
              final delta = offset - previousOffset;
              previousOffset = offset;
              if (delta > 8 && sheetController.size < 0.95) {
                sheetController.animateTo(
                  0.97,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                );
              }
            });
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;

            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  // ✨ MODIFIED: Dynamic background color
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // drag handle
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 4,
                        width: 72,
                        decoration: BoxDecoration(
                          // ✨ MODIFIED: Dynamic handle color
                          color:
                              isDarkMode ? Colors.grey[700] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // ✨ MODIFIED: Dynamic search bar background
                          color:
                              isDarkMode
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // ✨ MODIFIED: Dynamic icon and text colors
                            Icon(
                              Icons.search,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => NewGroupScreen(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.person_add,
                                color:
                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // The grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                childAspectRatio: 0.82,
                              ),
                          itemCount: contacts.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final c = contacts[index];
                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Share to ${c["name"]} (stub)',
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundImage: NetworkImage(c["avatar"]!),
                                    // ✨ MODIFIED: Dynamic fallback background
                                    backgroundColor:
                                        isDarkMode
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 88,
                                    child: Text(
                                      c["name"]!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        // ✨ MODIFIED: Dynamic name color
                                        color:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ✨ MODIFIED: Dynamic divider color
                    Divider(
                      color: isDarkMode ? Colors.white10 : Colors.black12,
                      thickness: 1,
                    ),
                    const SizedBox(height: 10),

                    //  bottom row of actions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 110,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              // ✨ MODIFIED: Pass isDarkMode to the helper
                              _actionButton(
                                icon: FontAwesomeIcons.whatsapp,
                                label: 'WhatsApp',
                                bg: const Color(0xFF25D366),
                                onTap: () {},
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 18),
                              _actionButton(
                                icon: Icons.add_circle,
                                label: 'WhatsApp\nStatus',
                                bg: const Color(0xFF25D366),
                                onTap: () {},
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 18),
                              _actionButton(
                                icon: Icons.add_box_rounded,
                                label: 'Post in\nstory',
                                onTap: () {},
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 18),
                              _actionButton(
                                icon: Icons.link,
                                label: 'Copy\nlink',
                                onTap: () {},
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 18),
                              _actionButton(
                                icon: Icons.share,
                                label: 'Share',
                                onTap: () {},
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleCaptionExpansion(int index) {
    setState(() {
      _isCaptionExpanded[index] = !_isCaptionExpanded[index];
    });
  }

  Widget _buildAnimatedHeart(int index) {
    return Positioned(
      left: _doubleTapPositions[index].dx - 50,
      top: _doubleTapPositions[index].dy - 50,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: _showHeartAnimation[index] ? 1.0 : 0.0,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: _showHeartAnimation[index] ? 1.2 : 0.5),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            // Apply both scale and rotation transforms
            return Transform.rotate(
              angle: _showHeartAnimation[index] ? _heartRotations[index] : 0,
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: ShaderMask(
            shaderCallback: (bounds) {
              return _heartGradients[_currentGradientIndexes[index]]
                  .createShader(bounds);
            },
            child: const Icon(
              FontAwesomeIcons.solidHeart,
              color: Colors.white,
              size: 80,
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black38)],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),

                // Top circular options row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MoreOption(
                      icon: Icons.bookmark_outline,
                      label: "Save",
                      onTap: () {
                        Navigator.of(ctx).pop();
                        // handle Save
                      },
                    ),
                    MoreOption(
                      iconWidget: const FaIcon(
                        FontAwesomeIcons.creativeCommonsRemix,
                        size: 22,
                      ),
                      label: "Remix",
                      onTap: () {
                        Navigator.of(ctx).pop();
                        // handle Remix
                      },
                    ),
                    MoreOption(
                      icon: Icons.add,
                      label: "Sequence",
                      onTap: () {
                        Navigator.of(ctx).pop();
                        // handle Sequence
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                // Use Flexible with SingleChildScrollView so sheet can grow if needed
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildListTile(
                          icon: Icons.fullscreen,
                          text: "View fullscreen",
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        _buildListTile(
                          icon: Icons.info_outline,
                          text: "Why you're seeing this post",
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                        _buildListTile(
                          icon: Icons.remove_red_eye_outlined,
                          text: "Interested",
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                        _buildListTile(
                          icon: Icons.visibility_off,
                          text: "Not interested",
                          onTap: () => Navigator.of(ctx).pop(),
                        ),

                        // Report row (red)
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            // handle report
                          },
                          leading: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.report,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                          title: Text(
                            "Report...",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Final item
                        _buildListTile(
                          icon: Icons.tune,
                          text: "Manage content preferences",
                          onTap: () => Navigator.of(ctx).pop(),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// small helper for standard list tiles
  Widget _buildListTile({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, size: 35),
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: trailing,
    );
  }

  Widget _buildRightActionColumn(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          icon:
              _isLiked[index]
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
          iconColor: _isLiked[index] ? Colors.pinkAccent : Colors.white,
          label: '87.5K',
          onTap: () {
            if (_isLiked[index]) {
              setState(() {
                _isLiked[index] = false;
              });
            } else {
              _triggerLikeAnimation(index);
            }
          },
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.comment,
          label: '1.2K',
          onTap: _showCommentModal,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.paperPlane,
          label: 'Share',
          onTap: () {
            _showShareModal(context);
          },
        ),
        _buildActionButton(
          icon: Icons.more_vert,
          onTap: () {
            _showMoreModal(context);
          },
        ),
        const SizedBox(height: 12),
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 3, // thicker border
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80',
              fit: BoxFit.cover, // fills the container
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color iconColor = Colors.white,
    String? label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, size: 28, color: iconColor),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80',
              ),
            ),
            const SizedBox(width: 10),

            Text(
              _usernames[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _toggleCaptionExpansion(index),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              _captions[index],
              style: const TextStyle(
                color: Colors.white,
                shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.music_note, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Expanded(
              child: SizedBox(
                height: 20,
                child: Marquee(
                  text: _musicNames[index],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTapDown: (details) {
                  _triggerLikeAnimation(
                    index,
                    tapPosition: details.localPosition,
                  );
                },
                onTap: () {
                  // Mute/unmute on tap
                  _toggleMute();
                  _triggerMuteAnimation(index);
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (_isVideoInitialized[index])
                      Chewie(controller: _chewieControllers[index])
                    else
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),

                    _buildAnimatedHeart(index),

                    if (_showMuteAnimation && _muteAnimationIndex == index)
                      _buildMuteAnimation(),

                    if (_isCaptionExpanded[index])
                      GestureDetector(
                        onTap: () => _toggleCaptionExpansion(index),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        ),
                      ),

                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: _buildRightActionColumn(index),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 16,
                      right: 80,
                      child: _buildBottomInfo(index),
                    ),

                    if (_isCaptionExpanded[index])
                      Center(
                        child: GestureDetector(
                          onTap: () => _toggleCaptionExpansion(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                _captions[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                  ),
                ),
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 28,
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
