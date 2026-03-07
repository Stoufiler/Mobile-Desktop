import '../models/user.dart';

/// Manages the current authenticated user.
class UserRepository {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User? user) {
    _currentUser = user;
  }
}
