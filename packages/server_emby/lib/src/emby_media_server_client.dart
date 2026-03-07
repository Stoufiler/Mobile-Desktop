import 'package:server_core/server_core.dart';

/// TODO: Implement Emby API endpoints.
class EmbyMediaServerClient extends MediaServerClient {
  final DeviceInfo deviceInfo;

  EmbyMediaServerClient({
    required String baseUrl,
    required this.deviceInfo,
  }) : _baseUrl = baseUrl;

  String _baseUrl;
  String? _accessToken;

  @override
  ServerType get serverType => ServerType.emby;

  @override
  String get baseUrl => _baseUrl;

  @override
  set baseUrl(String url) => _baseUrl = url;

  @override
  String? get accessToken => _accessToken;

  @override
  set accessToken(String? token) => _accessToken = token;

  @override
  AuthApi get authApi => throw UnimplementedError('Emby AuthApi');

  @override
  ItemsApi get itemsApi => throw UnimplementedError('Emby ItemsApi');

  @override
  PlaybackApi get playbackApi => throw UnimplementedError('Emby PlaybackApi');

  @override
  ImageApi get imageApi => throw UnimplementedError('Emby ImageApi');

  @override
  SessionApi get sessionApi => throw UnimplementedError('Emby SessionApi');

  @override
  SystemApi get systemApi => throw UnimplementedError('Emby SystemApi');

  @override
  UserLibraryApi get userLibraryApi =>
      throw UnimplementedError('Emby UserLibraryApi');

  @override
  UserViewsApi get userViewsApi =>
      throw UnimplementedError('Emby UserViewsApi');

  @override
  LiveTvApi get liveTvApi => throw UnimplementedError('Emby LiveTvApi');

  @override
  void dispose() {}
}
