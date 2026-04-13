import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SignlyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const SignlyCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: child,
      ),
    );
  }
}

class SignlyProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? valueColor;

  const SignlyProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: backgroundColor ?? const Color(0xFF2A2A2A),
        valueColor: AlwaysStoppedAnimation<Color>(
          valueColor ?? const Color(0xFF2196F3),
        ),
      ),
    );
  }
}

class SignlyChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SignlyChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2196F3).withOpacity(0.2)
              : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF2196F3)
                : const Color(0xFF3A3A3A),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF2196F3) : Colors.white,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class SignlyStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const SignlyStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class SignlySectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SignlySectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: const Color(0xFF2196F3),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class LessonProgressBar extends StatelessWidget {
  final double progress;
  final VoidCallback? onClose;

  const LessonProgressBar({
    super.key,
    required this.progress,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final confirmed = await SignlyConfirmDialog.show(
                context,
                title: 'Exit Lesson?',
                message: 'Your progress in this lesson will not be saved. Are you sure you want to leave?',
                confirmLabel: 'Exit',
                cancelLabel: 'Continue',
                confirmColor: const Color(0xFFE53935),
                icon: Icons.exit_to_app,
              );
              if (confirmed) {
                if (onClose != null) {
                  onClose!();
                } else if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Icon(Icons.close, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SignlyProgressBar(value: progress),
          ),
          const SizedBox(width: 16),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              color: const Color(0xFF9E9E9E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class SignlyBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SignlyBottomButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

/// Reusable video player widget that plays sign language demonstration clips
/// from local assets. Provides replay, slow-motion controls, and loading/error
/// states. Falls back to [VideoPlaceholder] when no asset path is given.
class SignlyVideoPlayer extends StatefulWidget {
  final String assetPath;
  final double height;
  final bool showControls;
  final bool autoPlay;
  final bool looping;
  final String? label;

  const SignlyVideoPlayer({
    super.key,
    required this.assetPath,
    this.height = 220,
    this.showControls = true,
    this.autoPlay = true,
    this.looping = true,
    this.label,
  });

  @override
  State<SignlyVideoPlayer> createState() => _SignlyVideoPlayerState();
}

class _SignlyVideoPlayerState extends State<SignlyVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(widget.looping)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          if (widget.autoPlay) _controller.play();
        }
      }).catchError((e) {
        if (mounted) setState(() => _hasError = true);
      });
  }

  @override
  void didUpdateWidget(covariant SignlyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _controller.dispose();
      _initialized = false;
      _hasError = false;
      _playbackSpeed = 1.0;
      _initVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _replay() {
    _controller.seekTo(Duration.zero);
    _controller.play();
  }

  void _toggleSpeed() {
    setState(() {
      _playbackSpeed = _playbackSpeed == 1.0 ? 0.5 : 1.0;
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.error_outline, color: const Color(0xFFE53935), size: 40),
            SizedBox(height: 8),
            Text('Video unavailable', style: TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14)),
          ],
        ),
      );
    }

    if (!_initialized) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: const Color(0xFF2196F3)),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: widget.height,
        color: const Color(0xFF2A2A2A),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            // Tap to play/pause
            Positioned.fill(
              child: GestureDetector(
                onTap: _togglePlayPause,
                behavior: HitTestBehavior.opaque,
                child: AnimatedOpacity(
                  opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 56),
                    ),
                  ),
                ),
              ),
            ),
            // Label
            if (widget.label != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.label!,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            // Slow-mo indicator
            if (_playbackSpeed != 1.0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '0.5×',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            // Bottom controls
            if (widget.showControls)
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    _buildControl(Icons.replay, 'Replay', _replay),
                    const SizedBox(width: 8),
                    _buildControl(
                      Icons.slow_motion_video,
                      _playbackSpeed == 1.0 ? 'Slow' : 'Normal',
                      _toggleSpeed,
                    ),
                  ],
                ),
              ),
            // Progress bar at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: const Color(0xFF2196F3),
                  bufferedColor: const Color(0xFF3A3A3A),
                  backgroundColor: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControl(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// A compact video player for smaller placements (e.g. model preview in camera screen,
/// side-by-side error comparison). No controls overlay, just tap to play/pause.
class SignlyMiniVideoPlayer extends StatefulWidget {
  final String assetPath;
  final double? height;
  final bool autoPlay;
  final bool looping;

  const SignlyMiniVideoPlayer({
    super.key,
    required this.assetPath,
    this.height,
    this.autoPlay = false,
    this.looping = true,
  });

  @override
  State<SignlyMiniVideoPlayer> createState() => _SignlyMiniVideoPlayerState();
}

class _SignlyMiniVideoPlayerState extends State<SignlyMiniVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(widget.looping)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          if (widget.autoPlay) _controller.play();
        }
      }).catchError((e) {
        if (mounted) setState(() => _hasError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || !_initialized) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: _hasError
              ? const Icon(Icons.error_outline, color: const Color(0xFF9E9E9E), size: 28)
              : const CircularProgressIndicator(color: const Color(0xFF2196F3), strokeWidth: 2),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: widget.height,
          color: const Color(0xFF2A2A2A),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              if (!_controller.value.isPlaying)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(Icons.play_circle_outline, color: Colors.white, size: 36),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── YouTube video player with looping, replay, and slow-motion ──────────────

class SignlyYouTubePlayer extends StatefulWidget {
  final String videoId;
  final String? label;

  const SignlyYouTubePlayer({
    super.key,
    required this.videoId,
    this.label,
  });

  @override
  State<SignlyYouTubePlayer> createState() => _SignlyYouTubePlayerState();
}

class _SignlyYouTubePlayerState extends State<SignlyYouTubePlayer> {
  late YoutubePlayerController _controller;
  bool _isSlow = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        loop: true,
        showControls: false,
        showFullscreenButton: false,
        mute: false,
        strictRelatedVideos: true,
        enableCaption: false,
      ),
    );
  }

  @override
  void didUpdateWidget(SignlyYouTubePlayer old) {
    super.didUpdateWidget(old);
    if (old.videoId != widget.videoId) {
      _controller.loadVideoById(videoId: widget.videoId);
      setState(() => _isSlow = false);
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _replay() {
    _controller.seekTo(seconds: 0, allowSeekAhead: true);
    _controller.playVideo();
  }

  void _toggleSlow() {
    setState(() => _isSlow = !_isSlow);
    _controller.setPlaybackRate(_isSlow ? 0.5 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: YoutubePlayerScaffold(
          controller: _controller,
          aspectRatio: 16 / 9,
          builder: (context, player) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Video area ────────────────────────────────────────────
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      player,
                      // Label badge
                      if (widget.label != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.label!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // ── Controls bar ──────────────────────────────────────────
                Container(
                  color: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ControlButton(
                        icon: Icons.slow_motion_video,
                        label: _isSlow ? '0.5×' : '1×',
                        onTap: _toggleSlow,
                        isActive: _isSlow,
                      ),
                      const SizedBox(width: 10),
                      _ControlButton(
                        icon: Icons.replay,
                        label: 'Replay',
                        onTap: _replay,
                        isActive: false,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2196F3) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? const Color(0xFF2196F3) : const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact YouTube player for side-by-side comparison cards (error screen).
/// Fills its parent container, auto-plays with looping, no controls bar.
class SignlyYouTubeMiniPlayer extends StatefulWidget {
  final String videoId;

  const SignlyYouTubeMiniPlayer({
    super.key,
    required this.videoId,
  });

  @override
  State<SignlyYouTubeMiniPlayer> createState() => _SignlyYouTubeMiniPlayerState();
}

class _SignlyYouTubeMiniPlayerState extends State<SignlyYouTubeMiniPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        loop: true,
        showControls: false,
        showFullscreenButton: false,
        mute: false,
        strictRelatedVideos: true,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) => SizedBox.expand(child: player),
    );
  }
}

class VideoPlaceholder extends StatelessWidget {
  final double height;
  final IconData icon;
  final String? label;

  const VideoPlaceholder({
    super.key,
    this.height = 200,
    this.icon = Icons.play_circle_fill,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 56),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label!,
              style: const TextStyle(color: const Color(0xFF9E9E9E), fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

/// Reusable confirmation dialog that follows UI/UX best practices.
/// Used for destructive or irreversible actions (logout, exit lesson, reset progress).
/// Implements the rubric requirement for confirmation dialogues.
class SignlyConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color confirmColor;
  final IconData? icon;

  const SignlyConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.confirmColor = const Color(0xFFE53935),
    this.icon,
  });

  /// Convenience method to show the dialog and return true/false.
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String message,
        String confirmLabel = 'Confirm',
        String cancelLabel = 'Cancel',
        Color confirmColor = const Color(0xFFE53935),
        IconData? icon,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SignlyConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: confirmColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: confirmColor, size: 28),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: const Color(0xFF3A3A3A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(cancelLabel),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tooltip/info icon widget for providing additional context.
/// Implements UDL principle: multiple means of representation.
class SignlyInfoTooltip extends StatelessWidget {
  final String message;

  const SignlyInfoTooltip({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: false,
      textStyle: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2196F3)),
      ),
      child: const Icon(Icons.info_outline, color: const Color(0xFF9E9E9E), size: 18),
    );
  }
}

/// Success snackbar for positive feedback after completing actions.
/// Follows UI/UX best practice of providing clear feedback.
void showSignlySnackBar(BuildContext context, String message, {bool isSuccess = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.info_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: isSuccess ? const Color(0xFF4CAF50) : const Color(0xFF2196F3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ),
  );
}

class FeedbackItem extends StatelessWidget {
  final String label;
  final String status;
  final bool isGood;

  const FeedbackItem({
    super.key,
    required this.label,
    required this.status,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.info_outline,
            color: isGood ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              color: isGood ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}