import 'package:get_it/get_it.dart';
import 'package:jellyfin_preference/jellyfin_preference.dart';
import 'package:server_core/server_core.dart';
import 'package:uuid/uuid.dart';

import '../auth/store/authentication_store.dart';
import '../data/database/database_connection.dart';
import '../data/database/offline_database.dart';
import '../data/repositories/offline_repository.dart';
import '../data/services/storage_path_service.dart';
import '../util/platform_detection.dart';
import 'modules/app_module.dart';
import 'modules/auth_module.dart';
import 'modules/server_module.dart';
import 'modules/playback_module.dart';
import 'modules/preference_module.dart';

final getIt = GetIt.instance;

String _clientName() {
  if (PlatformDetection.isAndroid) return 'Moonfin for Android';
  if (PlatformDetection.isIOS) return 'Moonfin for iOS';
  if (PlatformDetection.isMacOS) return 'Moonfin for macOS';
  if (PlatformDetection.isWindows) return 'Moonfin for Windows';
  if (PlatformDetection.isLinux) return 'Moonfin for Linux';
  return 'Moonfin';
}

Future<void> configureDependencies() async {
  final preferenceStore = PreferenceStore();
  await preferenceStore.init();

  var deviceId = preferenceStore.getString('device_id');
  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await preferenceStore.setString('device_id', deviceId);
  }

  final clientName = _clientName();
  getIt.registerSingleton<DeviceInfo>(DeviceInfo(
    id: deviceId,
    name: clientName,
    appName: clientName,
    appVersion: '0.1.0',
  ));

  registerPreferenceModule(preferenceStore);

  final storagePath = StoragePathService();
  getIt.registerSingleton<StoragePathService>(storagePath);
  getIt.registerSingleton<OfflineDatabase>(
    OfflineDatabase(openConnection(() => storagePath.getDatabaseFile())),
  );
  getIt.registerSingleton<OfflineRepository>(
    OfflineRepository(getIt<OfflineDatabase>()),
  );

  registerServerModule();
  registerAuthModule();
  await getIt<AuthenticationStore>().init();
  registerPlaybackModule();
  registerAppModule();
}
