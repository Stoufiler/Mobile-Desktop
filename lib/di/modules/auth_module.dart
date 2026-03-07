import 'package:get_it/get_it.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../auth/repositories/server_repository.dart';
import '../../auth/repositories/session_repository.dart';
import '../../auth/repositories/user_repository.dart';
import '../../auth/store/credential_store.dart';

final _getIt = GetIt.instance;

void registerAuthModule() {
  _getIt.registerLazySingleton(() => CredentialStore());
  _getIt.registerLazySingleton(() => ServerRepository(_getIt()));
  _getIt.registerLazySingleton(() => UserRepository());
  _getIt.registerLazySingleton(() => SessionRepository(_getIt(), _getIt()));
  _getIt.registerLazySingleton(
    () => AuthRepository(_getIt(), _getIt(), _getIt()),
  );
}
