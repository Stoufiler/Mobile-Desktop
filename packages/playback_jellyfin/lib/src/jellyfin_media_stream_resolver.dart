import 'package:playback_core/playback_core.dart';
import 'package:server_core/server_core.dart';

class JellyfinMediaStreamResolver implements MediaStreamResolver {
  final MediaServerClient _client;

  JellyfinMediaStreamResolver(this._client);

  @override
  Future<StreamResolutionResult> resolve(
    dynamic mediaItem, {
    Map<String, dynamic>? deviceProfile,
    int? maxStreamingBitrate,
    int? audioStreamIndex,
    int? subtitleStreamIndex,
    int? startTimeTicks,
  }) async {
    final itemId = mediaItem['Id'] as String;

    final request = PlaybackInfoRequest(
      itemId: itemId,
      deviceProfile: deviceProfile,
      maxStreamingBitrate: maxStreamingBitrate,
      audioStreamIndex: audioStreamIndex,
      subtitleStreamIndex: subtitleStreamIndex,
      startTimeTicks: startTimeTicks,
    );

    final rawInfo = await _client.playbackApi.getPlaybackInfo(
      itemId,
      requestBody: request.toJson(),
    );
    final info = PlaybackInfoResult.fromJson(rawInfo);

    if (info.errorCode != null) {
      throw Exception('Playback error: ${info.errorCode}');
    }
    if (info.mediaSources.isEmpty) {
      throw Exception('No media sources available for item $itemId');
    }

    final source = _selectBestSource(info.mediaSources);
    final (url, playMethod) = _resolveStreamUrl(itemId, source);

    return StreamResolutionResult(
      streamUrl: url,
      mediaSourceId: source.id,
      playSessionId: info.playSessionId,
      playMethod: playMethod,
    );
  }

  PlaybackMediaSource _selectBestSource(List<PlaybackMediaSource> sources) {
    PlaybackMediaSource? directStream;
    PlaybackMediaSource? transcode;
    for (final s in sources) {
      if (s.supportsDirectPlay) return s;
      directStream ??= s.supportsDirectStream ? s : null;
      transcode ??= s.supportsTranscoding ? s : null;
    }
    return directStream ?? transcode ?? sources.first;
  }

  (String, StreamPlayMethod) _resolveStreamUrl(
    String itemId,
    PlaybackMediaSource source,
  ) {
    if (source.supportsDirectPlay) {
      return (
        _client.playbackApi.getStreamUrl(itemId, mediaSourceId: source.id),
        StreamPlayMethod.directPlay,
      );
    }
    if (source.supportsDirectStream && source.directStreamUrl != null) {
      return (
        '${_client.baseUrl}${source.directStreamUrl}',
        StreamPlayMethod.directStream,
      );
    }
    if (source.supportsTranscoding && source.transcodingUrl != null) {
      return (
        '${_client.baseUrl}${source.transcodingUrl}',
        StreamPlayMethod.transcode,
      );
    }
    return (
      _client.playbackApi.getStreamUrl(itemId, mediaSourceId: source.id),
      StreamPlayMethod.directPlay,
    );
  }
}
