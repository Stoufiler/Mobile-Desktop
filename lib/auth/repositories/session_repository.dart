import '../store/credential_store.dart';
import 'server_repository.dart';

/// Manages the active server session and token lifecycle.
class SessionRepository {
  final CredentialStore _credentialStore;
  final ServerRepository _serverRepository;

  String? _activeServerId;

  SessionRepository(this._credentialStore, this._serverRepository);

  String? get activeServerId => _activeServerId;

  /// Set the active server and restore its token.
  Future<String?> setActiveServer(String serverId) async {
    _activeServerId = serverId;
    return _credentialStore.getToken(serverId);
  }

  /// Save the current session's access token.
  Future<void> saveToken(String serverId, String token) async {
    await _credentialStore.saveToken(serverId, token);
  }

  /// Clear the active session.
  Future<void> clearSession() async {
    if (_activeServerId != null) {
      await _credentialStore.deleteToken(_activeServerId!);
    }
    _activeServerId = null;
  }
}
