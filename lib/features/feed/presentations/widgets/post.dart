import 'package:flutter/material.dart';
import 'package:instagram/features/feed/presentations/widgets/collapsable_caption.dart';
import 'package:marquee/marquee.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  // Dummy media list. Each item will have a 'type' = 'image' | 'video' and 'url'
  // Later you can swap this with an API response and support multiple media (carousel).
  final List<Map<String, String>> media = [
    // Toggle between image/video by changing the first item.type
    // Example: for image post, keep the first as image (as below).
    {
      'type': 'image',
      'url':
          "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?cs=srgb&dl=pexels-pixabay-206359.jpg&fm=jpg",
    },

    // Example video item (unused for an image post). Swap order to test video:
    // {
    //   'type': 'video',
    //   'url':
    //       'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    //   'userProfileUrl':
    //       'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80',
    // },
  ];

  // Image aspect ratio handling (same approach as you had)
  double? _imageAspectRatio;
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;

  // Video player controller
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  bool _isMuted = true;
  bool _isPlaying = false;

  // safety cap so the media doesn't get insanely tall
  final double maxMediaHeight = 700.0;

  @override
  void initState() {
    super.initState();
    // If first media is image -> resolve it for aspect ratio
    if (_firstMediaType() == 'image') {
      _resolveImage(media.first['url']!);
    } else if (_firstMediaType() == 'video') {
      _initVideo(media.first['url']!);
    }
  }

  @override
  void dispose() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    _videoController?.dispose();
    super.dispose();
  }

  String? _firstMediaType() => media.isNotEmpty ? media.first['type'] : null;

  // ------------- Image helpers -------------
  void _resolveImage(String imageUrl) {
    final provider = NetworkImage(imageUrl);
    final oldStream = _imageStream;
    _imageStream = provider.resolve(const ImageConfiguration());
    if (_imageStream!.key != oldStream?.key) {
      _imageListener = ImageStreamListener(
        (ImageInfo info, bool _) {
          final w = info.image.width.toDouble();
          final h = info.image.height.toDouble();
          if (mounted) {
            setState(() {
              _imageAspectRatio = (w / h);
            });
          }
        },
        onError: (dynamic _, __) {
          // ignore errors for now
        },
      );

      if (oldStream != null && _imageListener != null) {
        oldStream.removeListener(_imageListener!);
      }
      _imageStream!.addListener(_imageListener!);
    }
  }

  // ------------- Video helpers -------------
  Future<void> _initVideo(String url) async {
    _videoController = VideoPlayerController.network(url);
    try {
      await _videoController!.initialize();
      // By default: muted & paused
      _videoController!.setVolume(0.0);
      setState(() {
        _videoInitialized = true;
        _isMuted = true;
        _isPlaying = false;
      });

      // Optional: play automatically (Instagram-style), comment out if not desired
      // _videoController!.play();
      // setState(() { _isPlaying = true; });
    } catch (e) {
      // handle init error if needed
      if (mounted) {
        setState(() {
          _videoInitialized = false;
        });
      }
    }

    // Listen for play/pause changes to update UI
    _videoController!.addListener(() {
      if (!mounted) return;
      final playing = _videoController!.value.isPlaying;
      if (playing != _isPlaying) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
  }

  void _toggleVideoPlayPause() {
    if (!(_videoController?.value.isInitialized ?? false)) return;
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
    setState(() {
      _isPlaying = _videoController!.value.isPlaying;
    });
  }

  void _toggleMute() {
    if (!(_videoController?.value.isInitialized ?? false)) return;
    if (_isMuted) {
      _videoController!.setVolume(1.0);
    } else {
      _videoController!.setVolume(0.0);
    }
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  // ------------- Build UI -------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // find first media url
    final firstMedia = media.isNotEmpty ? media.first : null;
    final firstType = firstMedia?['type'];
    final firstUrl = firstMedia?['url'];

    // Determine calculated height based on media type:
    double calculatedHeight;

    if (firstType == 'image') {
      if (_imageAspectRatio != null && _imageAspectRatio! > 0) {
        calculatedHeight = screenWidth / _imageAspectRatio!;
      } else {
        calculatedHeight = 300; // placeholder while loading
      }
    } else if (firstType == 'video') {
      if (_videoInitialized &&
          _videoController != null &&
          _videoController!.value.aspectRatio > 0) {
        calculatedHeight = screenWidth / _videoController!.value.aspectRatio;
      } else {
        // reasonable default for vertical-ish videos (Instagram favors tall aspect ratios)
        calculatedHeight = screenWidth * (16 / 9); // default landscape-ish
      }
    } else {
      calculatedHeight = 300;
    }

    final double displayHeight = calculatedHeight.clamp(0, maxMediaHeight);

    // Top info (username + music marquee). For images: keep above media.
    // For videos: overlay on top-left inside the media (per IG).
    final topInfoWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // avatar + username + music details
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Image.network(
                    // using first media as avatar source for dummy — swap later
                    'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80',
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
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 200,
                    child: Marquee(
                      text: "🎵 Love you like a love song - Selena Gomez",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 40.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      startPadding: 10.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
        ],
      ),
    );

    // For video we want topInfo overlayed with smaller paddings
    final overlayTopInfoForVideo = Positioned(
      left: 8,
      top: 8,
      right: 8,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Image.network(media.first['url']!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ra jandroh',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Icon(Icons.music_note, color: Colors.white70, size: 14),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'rajandroh • Original audio',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Mute button bottom-right for video
    final videoMuteButton = Positioned(
      right: 12,
      bottom: 12,
      child: GestureDetector(
        onTap: _toggleMute,
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // For image posts -> topInfo shown above the media (keeps layout separate)
        if (firstType == 'image') topInfoWidget,

        // The media area: either a plain SizedBox with network image or a Stack with video + overlays
        SizedBox(
          width: screenWidth,
          height: displayHeight,
          child: ClipRect(
            child: Builder(
              builder: (context) {
                if (firstType == 'image') {
                  // Image post: edge-to-edge image
                  final imageUrl = firstUrl!;
                  return Image.network(
                    imageUrl,
                    width: screenWidth,
                    height: displayHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      final p =
                          progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null;
                      return Container(
                        width: screenWidth,
                        height: displayHeight,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(value: p),
                      );
                    },
                    errorBuilder:
                        (context, error, stack) => Container(
                          width: screenWidth,
                          height: displayHeight,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        ),
                  );
                } else if (firstType == 'video') {
                  // Video post: stack to overlay top info and controls
                  if (!_videoInitialized || _videoController == null) {
                    // show placeholder while initializing
                    return Container(
                      width: screenWidth,
                      height: displayHeight,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Video
                      FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),

                      // Top-left overlayed info (username + audio)
                      overlayTopInfoForVideo,
                      // bottom-right mute button
                      videoMuteButton,
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),

        // For video posts -> show top info below only as spacing (we already overlayed info)
        if (firstType == 'video') const SizedBox(height: 8),

        // Bottom info (likes, comments, caption) — same for both image and video
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            children: [
              // like, comment and other buttons (row)
              Row(
                children: [
                  // Like
                  Icon(FontAwesomeIcons.heart, size: 27),
                  const SizedBox(width: 7),
                  const Text('11.8K'),

                  const SizedBox(width: 20),

                  // comment
                  Icon(FontAwesomeIcons.comment, size: 27),
                  const SizedBox(width: 7),
                  const Text('135'),

                  const SizedBox(width: 20),

                  // share
                  Icon(FontAwesomeIcons.shareNodes, size: 24),
                  const SizedBox(width: 7),
                  const Text('1.8K'),

                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 11),
              // caption
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "username",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CollapsibleCaption(
                      text:
                          "Your belief is ALL that matters sdfshsdfhsduhfusdhfusdfuisdfiusdfuygdsiufg",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Time stamp
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [Text('13 hours ago')],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
