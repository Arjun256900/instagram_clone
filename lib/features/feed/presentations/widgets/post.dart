import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/feed/presentations/widgets/collapsable_caption.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  final List<Map<String, String>> media;
  const Post({super.key, required this.media});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int _currentIndex = 0;
  final Map<int, double> _imageAspectRatios = {};
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Set<int> _initializingVideos = {};
  bool _isMuted = true;
  final double maxMediaHeight = 700.0;

  // State variable to hold the fixed height of the carousel.
  double? _carouselHeight;

  @override
  void initState() {
    super.initState();
    // resolving the first media item to determine the fixed height for a multi media post
    if (widget.media.isNotEmpty) {
      _resolveFirstMediaHeight();
    }
  }

  @override
  void dispose() {
    for (final c in _videoControllers.values) {
      c.pause();
      c.dispose();
    }
    _videoControllers.clear();
    super.dispose();
  }

  // method to resolve the height of the first item.
  void _resolveFirstMediaHeight() {
    final firstItem = widget.media[0];
    if (firstItem['type'] == 'image') {
      _resolveImageForIndex(0, setCarouselHeight: true);
    } else if (firstItem['type'] == 'video') {
      _initVideoAtIndex(0, setCarouselHeight: true);
    }
  }

  // set the fixed carousel height.
  void _resolveImageForIndex(int index, {bool setCarouselHeight = false}) {
    if (widget.media[index]['type'] != 'image' ||
        _imageAspectRatios.containsKey(index)) {
      return;
    }

    final provider = NetworkImage(widget.media[index]['url']!);
    final stream = provider.resolve(const ImageConfiguration());
    late final ImageStreamListener listener;

    listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!mounted) return;
      final aspect = info.image.width / info.image.height;
      setState(() {
        _imageAspectRatios[index] = aspect;
        // Only set the fixed height if this is the first item.
        if (setCarouselHeight && _carouselHeight == null) {
          final screenWidth = MediaQuery.of(context).size.width;
          _carouselHeight = (screenWidth / aspect).clamp(0, maxMediaHeight);
        }
      });
      stream.removeListener(listener);
    }, onError: (_, __) => stream.removeListener(listener));
    stream.addListener(listener);
  }

  // ✨ BUG FIX: Modified to optionally set the fixed carousel height.
  Future<void> _initVideoAtIndex(
    int index, {
    bool setCarouselHeight = false,
  }) async {
    if (widget.media[index]['type'] != 'video' ||
        _videoControllers.containsKey(index) ||
        _initializingVideos.contains(index)) {
      return;
    }

    _initializingVideos.add(index);
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.media[index]['url']!),
    );
    _videoControllers[index] = controller;

    try {
      await controller.initialize();
      controller.setVolume(_isMuted ? 0.0 : 1.0);
      controller.setLooping(true);

      if (!mounted) return;
      setState(() {
        // Only set the fixed height if this is the first item.
        if (setCarouselHeight && _carouselHeight == null) {
          final screenWidth = MediaQuery.of(context).size.width;
          _carouselHeight = (screenWidth / controller.value.aspectRatio).clamp(
            0,
            maxMediaHeight,
          );
        }
      });

      if (_currentIndex == index) controller.play();
    } finally {
      _initializingVideos.remove(index);
    }
  }

  void _toggleMute() {
    final controller = _videoControllers[_currentIndex];
    if (controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _onPageChanged(int idx, CarouselPageChangedReason reason) {
    if (!mounted) return;

    // Pause previous video
    final prevController = _videoControllers[_currentIndex];
    if (prevController != null && prevController.value.isPlaying) {
      prevController.pause();
    }

    setState(() {
      _currentIndex = idx;
    });

    final currentItem = widget.media[idx];
    if (currentItem['type'] == 'image') {
      _resolveImageForIndex(idx);
    } else if (currentItem['type'] == 'video') {
      _initVideoAtIndex(idx).then((_) {
        // Autoplay the new video
        final controller = _videoControllers[idx];
        if (controller != null && mounted && _currentIndex == idx) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ THEME: Check for dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Use the fixed _carouselHeight. Provide a fallback while it's being calculated.
    final double displayHeight = _carouselHeight ?? screenWidth * 1.25;

    // Top info widget
    final topInfoWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // avatar
              SizedBox(
                height: 33,
                width: 33,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1180&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'kd.musclefreak',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 170,
                    child: Text(
                      "🎵Love you like a love song - Selena Gomez",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white12 : Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Follow',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.more_vert,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ],
      ),
    );

    // Number indicator overlay
    Widget totalMediaInPostWidget(int idx) => Positioned(
      top: 15,
      right: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? Color.fromRGBO(0, 0, 0, 0.6)
                  : Color.fromRGBO(0, 0, 0, 0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          '${idx + 1}/${widget.media.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Mute button overlay
    final videoMuteButton = Positioned(
      right: 15,
      bottom: 15,
      child: GestureDetector(
        onTap: _toggleMute,
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Color.fromRGBO(0, 0, 0, 0.6)
                    : Color.fromRGBO(0, 0, 0, 0.4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        topInfoWidget,

        // Carousel area with fixed height
        SizedBox(
          width: screenWidth,
          height: displayHeight,
          child: Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.media.length,
                itemBuilder: (context, itemIndex, realIndex) {
                  final m = widget.media[itemIndex];
                  if (m['type'] == 'image') {
                    return Image.network(
                      m['url']!,
                      key: ValueKey(
                        m['url'],
                      ), // helps Flutter reuse images correctly
                      gaplessPlayback:
                          true, // prevents flicker / broken image when source re-attaches
                      width: screenWidth,
                      height: displayHeight,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.grey[200],
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stack) => Container(
                            color:
                                isDarkMode
                                    ? Colors.grey[900]
                                    : Colors.grey[200],
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image,
                              color:
                                  isDarkMode ? Colors.white38 : Colors.black26,
                            ),
                          ),
                    );
                  } else if (m['type'] == 'video') {
                    final controller = _videoControllers[itemIndex];
                    if (controller == null || !controller.value.isInitialized) {
                      _initVideoAtIndex(itemIndex);
                      return Container(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                options: CarouselOptions(
                  height: displayHeight,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: _onPageChanged,
                ),
              ),
              // Overlays for video and multiple items
              if (widget.media[_currentIndex]['type'] == 'video')
                videoMuteButton,
              if (widget.media.length > 1)
                totalMediaInPostWidget(_currentIndex),
            ],
          ),
        ),

        // Bottom info (likes, comments, caption)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 22,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '11.8K',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    FontAwesomeIcons.comment,
                    size: 22,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '135',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    FontAwesomeIcons.shareNodes,
                    size: 20,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '1.8K',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CollapsibleCaption(
                      text:
                          "Your belief is ALL that matters sdfshsdfhsduhfusdhfusdfuisdfiusdfuygdsiufg",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '13 hours ago',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
