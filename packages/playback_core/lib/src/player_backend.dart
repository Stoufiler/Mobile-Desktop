/// Wraps platform-specific players (e.g., media_kit, ExoPlayer).
abstract class PlayerBackend {
  Future<void> play(dynamic mediaItem);
  Future<void> pause();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Duration get position;
  Duration get duration;
  bool get isPlaying;
  Stream<Duration> get positionStream;
  Stream<bool> get playingStream;
  void dispose();
}
