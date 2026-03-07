abstract class SessionApi {
  Future<void> reportCapabilities(Map<String, dynamic> capabilities);
  Future<List<Map<String, dynamic>>> getSessions();

  /// Send a command to another session (e.g., remote control).
  Future<void> sendCommand(String sessionId, Map<String, dynamic> command);
}
