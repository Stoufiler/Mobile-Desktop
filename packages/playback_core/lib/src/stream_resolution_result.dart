enum StreamPlayMethod { directPlay, directStream, transcode }

class StreamResolutionResult {
  final String streamUrl;
  final String mediaSourceId;
  final String? playSessionId;
  final StreamPlayMethod playMethod;

  const StreamResolutionResult({
    required this.streamUrl,
    required this.mediaSourceId,
    this.playSessionId,
    required this.playMethod,
  });
}
