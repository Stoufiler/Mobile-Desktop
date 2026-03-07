import '../models/server_type.dart';

/// Detects what features a server supports based on its type and version.
class FeatureDetector {
  final ServerType serverType;
  final String serverVersion;

  const FeatureDetector({
    required this.serverType,
    required this.serverVersion,
  });

  bool get supportsSyncPlay => serverType == ServerType.jellyfin;
  bool get supportsTrickplay => serverType == ServerType.jellyfin;
  bool get supportsLyrics => serverType == ServerType.jellyfin;

  /// Intro/credits detection.
  bool get supportsMediaSegments => serverType == ServerType.jellyfin;
}
