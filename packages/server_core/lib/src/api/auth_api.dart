abstract class AuthApi {
  Future<Map<String, dynamic>> authenticateByName(
    String username,
    String password,
  );

  Future<Map<String, dynamic>> authenticateWithQuickConnect(String secret);

  Future<void> logout();
}
