abstract class PlaybackApi {
  Future<void> reportPlaybackStart(Map<String, dynamic> info);
  Future<void> reportPlaybackProgress(Map<String, dynamic> info);
  Future<void> reportPlaybackStopped(Map<String, dynamic> info);

  /// Get playback info / media sources for an item.
  Future<Map<String, dynamic>> getPlaybackInfo(
    String itemId, {
    Map<String, dynamic>? deviceProfile,
  });

  /// Get an HLS stream URL for an item.
  String getStreamUrl(
    String itemId, {
    String? mediaSourceId,
    String? audioStreamIndex,
    String? subtitleStreamIndex,
  });
}
