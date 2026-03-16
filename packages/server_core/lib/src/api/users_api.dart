import '../models/system_models.dart';

abstract class UsersApi {
  Future<UserConfiguration> getUserConfiguration();
  Future<void> updateUserConfiguration(UserConfiguration config);
}
