/// Quality presets for downloading media with server-side transcoding.
///
/// When [isTranscoded] is true, the server uses ffmpeg to re-encode the media
/// to the specified bitrate/resolution. The download streams in real-time at
/// encoding speed. Transcoded downloads cannot be resumed if interrupted.
enum DownloadQuality {
  original,
  high1080p,
  medium720p,
  low480p,
  mobile360p;

  String get label => switch (this) {
        original => 'Original',
        high1080p => 'High (1080p)',
        medium720p => 'Medium (720p)',
        low480p => 'Low (480p)',
        mobile360p => 'Mobile (360p)',
      };

  String get estimatedSizePerHour => switch (this) {
        original => 'Varies',
        high1080p => '~3.6 GB/hr',
        medium720p => '~1.8 GB/hr',
        low480p => '~900 MB/hr',
        mobile360p => '~450 MB/hr',
      };

  int? get videoBitRate => switch (this) {
        original => null,
        high1080p => 8000000,
        medium720p => 4000000,
        low480p => 2000000,
        mobile360p => 1000000,
      };

  int? get maxWidth => switch (this) {
        original => null,
        high1080p => 1920,
        medium720p => 1280,
        low480p => 854,
        mobile360p => 640,
      };

  int? get audioBitRate => switch (this) {
        original => null,
        high1080p => 192000,
        medium720p => 128000,
        low480p => 96000,
        mobile360p => 64000,
      };

  String get videoCodec => 'h264';
  String get audioCodec => 'aac';
  String get container => 'mp4';
  int? get audioChannels => this == original ? null : 2;

  bool get isTranscoded => this != original;
}
