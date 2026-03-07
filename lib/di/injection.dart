import 'package:get_it/get_it.dart';
import 'package:jellyfin_preference/jellyfin_preference.dart';

import 'modules/app_module.dart';
import 'modules/auth_module.dart';
import 'modules/server_module.dart';
import 'modules/playback_module.dart';
import 'modules/preference_module.dart';

final getIt = GetIt.instance;

/// Configure all dependency injection bindings.
Future<void> configureDependencies() async {
  final preferenceStore = PreferenceStore();
  await preferenceStore.init();

  registerPreferenceModule(preferenceStore);
  registerServerModule();
  registerAuthModule();
  registerPlaybackModule();
  registerAppModule();
}
