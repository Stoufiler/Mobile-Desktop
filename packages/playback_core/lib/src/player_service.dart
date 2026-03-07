/// Hooks into playback lifecycle events (e.g., server reporting, lyrics, media session).
abstract class PlayerService {
  Future<void> onPlaybackStart(dynamic mediaItem);
  Future<void> onPlaybackProgress(Duration position);
  Future<void> onPlaybackStop(Duration position);
  void dispose();
}
