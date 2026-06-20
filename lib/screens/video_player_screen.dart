import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class InAppVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool startInFullscreen;

  const InAppVideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.startInFullscreen = false,
  });

  @override
  State<InAppVideoPlayerScreen> createState() => _InAppVideoPlayerScreenState();
}

class _InAppVideoPlayerScreenState extends State<InAppVideoPlayerScreen> {
  // YouTube videos are played by the self-contained [YoutubePlayer] widget,
  // which provides its own controls, seeking and fullscreen handling. Direct
  // video URLs use [VideoPlayerController] with the custom controls below.
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;

  bool _isReady = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isFullscreenMode = false;
  bool _wasPlaying = false;
  Timer? _controlsHideTimer;

  late final bool _isYouTubeVideo;

  @override
  void initState() {
    super.initState();

    final youtubeVideoId =
        YoutubePlayerController.convertUrlToId(widget.videoUrl);
    _isYouTubeVideo = youtubeVideoId != null && youtubeVideoId.isNotEmpty;

    if (_isYouTubeVideo) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: youtubeVideoId!,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: false,
          showFullscreenButton: false,
          mute: false,
          loop: false,
        ),
      );
      _isReady = true;
      return;
    }

    _isFullscreenMode = widget.startInFullscreen;
    _configureSystemUi(_isFullscreenMode);

    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..addListener(_handlePlaybackStateChanged);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final controller = _videoController;
      if (controller == null) {
        throw StateError('Video controller is not available');
      }

      await controller.initialize().timeout(const Duration(seconds: 12),
          onTimeout: () {
        throw TimeoutException('Video initialization timed out');
      });
      await controller.setLooping(false);
      await controller.play();
      if (!mounted) return;
      setState(() {
        _isReady = true;
        _wasPlaying = true;
        _showControls = false;
      });
      _scheduleControlsAutoHide();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  Future<void> _configureSystemUi(bool fullscreen) async {
    if (fullscreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      return;
    }

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _toggleFullscreen() async {
    final next = !_isFullscreenMode;
    _isFullscreenMode = next;
    await _configureSystemUi(next);

    if (mounted) {
      setState(() {});
    }
  }

  bool get _isCurrentlyPlaying => _videoController?.value.isPlaying ?? false;

  void _scheduleControlsAutoHide() {
    _controlsHideTimer?.cancel();

    if (!_isReady || !_isCurrentlyPlaying) {
      return;
    }

    _controlsHideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || !_isCurrentlyPlaying) return;

      setState(() {
        _showControls = false;
      });
    });
  }

  void _handlePlaybackStateChanged() {
    if (!mounted || !_isReady) return;

    final isPlaying = _isCurrentlyPlaying;
    if (isPlaying == _wasPlaying) {
      return;
    }

    _wasPlaying = isPlaying;

    if (isPlaying) {
      setState(() {
        _showControls = true;
      });
      _scheduleControlsAutoHide();
      return;
    }

    _controlsHideTimer?.cancel();
    setState(() {
      _showControls = true;
    });
  }

  void _handlePlayerTap() {
    if (!_isReady) return;

    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _scheduleControlsAutoHide();
    } else {
      _controlsHideTimer?.cancel();
    }
  }

  void _togglePlayback() {
    final controller = _videoController;
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
      _scheduleControlsAutoHide();
    }
  }

  @override
  void dispose() {
    _controlsHideTimer?.cancel();
    _videoController?.removeListener(_handlePlaybackStateChanged);
    _videoController?.dispose();
    _youtubeController?.close();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isYouTubeVideo) {
      return _buildYouTubePlayer();
    }
    return _buildDirectVideoPlayer(context);
  }

  Widget _buildYouTubePlayer() {
    final controller = _youtubeController;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: controller == null
              ? const Text(
                  'Unable to play this video',
                  style: TextStyle(color: Colors.white),
                )
              : YoutubePlayer(
                  controller: controller,
                  aspectRatio: 16 / 9,
                ),
        ),
      ),
    );
  }

  Widget _buildDirectVideoPlayer(BuildContext context) {
    final media = MediaQuery.of(context);
    final isFullscreen = _isFullscreenMode;
    final videoController = _videoController;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isFullscreen
          ? null
          : AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
      body: SafeArea(
        top: !isFullscreen,
        bottom: !isFullscreen,
        child: GestureDetector(
          onTap: _handlePlayerTap,
          child: Stack(
            children: [
              Center(
                child: _hasError
                    ? const Text(
                        'Unable to play this video',
                        style: TextStyle(color: Colors.white),
                      )
                    : !_isReady
                        ? const CircularProgressIndicator(color: Colors.white)
                        : AspectRatio(
                            aspectRatio: videoController!.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          ),
              ),
              if (_showControls && _isReady) ...[
                Positioned.fill(
                  child: Container(color: Colors.black38),
                ),
                Center(
                  child: IconButton(
                    iconSize: 72,
                    color: Colors.white,
                    onPressed: _togglePlayback,
                    icon: Icon(
                      videoController!.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomBar(),
                ),
              ],
              if (isFullscreen && _showControls)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: media.padding.top + 4,
                      left: 4,
                      right: 12,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _toggleFullscreen,
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TextStyle get _seekTimeTextStyle => TextStyle(
        color: Colors.white70,
        fontSize: _isFullscreenMode ? 10 : 12,
        fontWeight: FontWeight.w500,
      );

  Widget _buildBottomBar() {
    final controller = _videoController;
    if (controller == null) return const SizedBox.shrink();

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final duration = value.duration;
        final maxMs = duration.inMilliseconds;
        final positionMs = value.position.inMilliseconds;
        final hasDuration = maxMs > 0;
        return _buildBottomBarContent(
          context: context,
          currentTime: value.position,
          totalTime: duration,
          sliderValue:
              hasDuration ? positionMs.clamp(0, maxMs).toDouble() : 0.0,
          sliderMax: hasDuration ? maxMs.toDouble() : 1.0,
          onSeek: hasDuration
              ? (v) => controller.seekTo(Duration(milliseconds: v.round()))
              : null,
        );
      },
    );
  }

  Widget _buildBottomBarContent({
    required BuildContext context,
    required Duration currentTime,
    required Duration totalTime,
    required double sliderValue,
    required double sliderMax,
    required ValueChanged<double>? onSeek,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_formatDuration(currentTime), style: _seekTimeTextStyle),
          const SizedBox(width: 4),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white30,
                thumbColor: Colors.white,
                overlayColor: Colors.white24,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                min: 0,
                max: sliderMax,
                value: sliderValue,
                onChanged: onSeek,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(_formatDuration(totalTime), style: _seekTimeTextStyle),
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(
              _isFullscreenMode ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            iconSize: 22,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
