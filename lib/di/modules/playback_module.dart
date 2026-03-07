import 'package:get_it/get_it.dart';
import 'package:playback_core/playback_core.dart' show PlaybackManager;

final _getIt = GetIt.instance;

void registerPlaybackModule() {
  _getIt.registerLazySingleton(() => PlaybackManager());
}
