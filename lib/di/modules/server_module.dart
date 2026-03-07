import 'package:get_it/get_it.dart';
import 'package:server_core/server_core.dart';

final _getIt = GetIt.instance;

void registerServerModule() {
  _getIt.registerLazySingleton<MediaServerClient>(
    () => throw StateError(
      'MediaServerClient not configured. '
      'Call setServerClient() after server selection.',
    ),
  );
}

/// Replace the MediaServerClient singleton with a concrete implementation.
void setServerClient(MediaServerClient client) {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<MediaServerClient>()) {
    getIt.unregister<MediaServerClient>();
  }
  getIt.registerSingleton<MediaServerClient>(client);
}
