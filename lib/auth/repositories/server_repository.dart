import 'package:jellyfin_preference/jellyfin_preference.dart';

import '../models/server.dart';

/// Manages saved server connections.
class ServerRepository {
  final PreferenceStore _store;
  final List<Server> _servers = [];

  ServerRepository(this._store);

  List<Server> get servers => List.unmodifiable(_servers);

  /// Load saved servers from storage.
  Future<void> loadServers() async {
    // TODO: Load from preference store
  }

  /// Add a new server connection.
  Future<void> addServer(Server server) async {
    _servers.add(server);
    // TODO: Persist to storage
  }

  /// Remove a server connection.
  Future<void> removeServer(String serverId) async {
    _servers.removeWhere((s) => s.id == serverId);
    // TODO: Persist removal
  }

  /// Discover servers on the local network.
  Future<List<Server>> discoverServers() async {
    // TODO: Implement UDP broadcast discovery
    return [];
  }
}
