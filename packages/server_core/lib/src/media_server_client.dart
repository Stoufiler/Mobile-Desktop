import 'models/server_type.dart';
import 'api/auth_api.dart';
import 'api/items_api.dart';
import 'api/playback_api.dart';
import 'api/image_api.dart';
import 'api/session_api.dart';
import 'api/system_api.dart';
import 'api/user_library_api.dart';
import 'api/user_views_api.dart';
import 'api/live_tv_api.dart';

/// Abstract client for communicating with a media server (Jellyfin or Emby).
abstract class MediaServerClient {
  ServerType get serverType;

  String get baseUrl;
  set baseUrl(String url);

  String? get accessToken;
  set accessToken(String? token);

  AuthApi get authApi;
  ItemsApi get itemsApi;
  PlaybackApi get playbackApi;
  ImageApi get imageApi;
  SessionApi get sessionApi;
  SystemApi get systemApi;
  UserLibraryApi get userLibraryApi;
  UserViewsApi get userViewsApi;
  LiveTvApi get liveTvApi;

  void dispose();
}
