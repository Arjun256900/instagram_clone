import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instagram/features/reels/presentations/widgets/comment_modal.dart';
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
      colors: [Color(0xFFfeda75), Color(0xfef07e1), Color(0xffc13584)],
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
    if (index < _videoControllers.length && _videoControllers[index] != null) {
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
          onTap: () {},
        ),
        _buildActionButton(icon: Icons.more_vert, onTap: () {}),
        const SizedBox(height: 12),
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[800],
          child: const Icon(Icons.music_note, color: Colors.white, size: 20),
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
                  if (_chewieControllers.length > index &&
                      _chewieControllers[index] != null) {
                    final controller = _chewieControllers[index];
                    if (controller.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  }
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

                    if (_isCaptionExpanded[index])
                      GestureDetector(
                        onTap: () => _toggleCaptionExpansion(index),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),

                    Positioned(
                      bottom: 20,
                      right: 10,
                      child: _buildRightActionColumn(index),
                    ),

                    Positioned(
                      bottom: 20,
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
                              color: Colors.black.withOpacity(0.7),
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
