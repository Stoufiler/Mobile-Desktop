import 'dart:async';

import '../models/login_state.dart';
import 'server_repository.dart';
import 'session_repository.dart';
import 'user_repository.dart';

/// Orchestrates the authentication flow.
class AuthRepository {
  final ServerRepository _serverRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  final _stateController =
      StreamController<LoginState>.broadcast();

  AuthRepository(
    this._serverRepository,
    this._sessionRepository,
    this._userRepository,
  );

  Stream<LoginState> get stateStream => _stateController.stream;

  /// Attempt to restore a previous session on startup.
  Future<void> restoreSession() async {
    _stateController.add(const LoginStateLoading());

    await _serverRepository.loadServers();
    if (_serverRepository.servers.isEmpty) {
      _stateController.add(const LoginStateServerSelection());
      return;
    }

    // TODO: Check last active server and restore token
    _stateController.add(const LoginStateServerSelection());
  }

  /// Authenticate with username and password.
  Future<void> login(String serverId, String username, String password) async {
    _stateController.add(const LoginStateLoading());

    try {
      // TODO: Call server API to authenticate
      // final result = await client.authApi.authenticateByName(username, password);
      // final user = User.fromJson(result);
      // _userRepository.setCurrentUser(user);
      // await _sessionRepository.saveToken(serverId, result['AccessToken']);

      _stateController.add(LoginStateAuthenticated(
        userId: 'TODO',
        serverId: serverId,
      ));
    } catch (e) {
      _stateController.add(LoginStateError(message: e.toString()));
    }
  }

  /// Sign out and clear the session.
  Future<void> logout() async {
    _userRepository.setCurrentUser(null);
    await _sessionRepository.clearSession();
    _stateController.add(const LoginStateServerSelection());
  }

  void dispose() {
    _stateController.close();
  }
}
