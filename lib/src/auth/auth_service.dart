class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  static bool _isAuthenticated = false;
  bool get isAuthenticated {
    return _isAuthenticated;
  }

  set setAuthenticated(value) {
    _isAuthenticated = value;
  }
}
