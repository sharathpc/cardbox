import 'package:local_auth/local_auth.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final LocalAuthentication auth = LocalAuthentication();
  static bool _isAuthenticated = false;
  bool get isAuthenticated {
    return _isAuthenticated;
  }

  set setAuthenticated(value) {
    _isAuthenticated = value;
  }

  Future<bool> authenticate() async {
    return AuthService.instance.setAuthenticated = await auth.authenticate(
      localizedReason: 'Authenticate',
      useErrorDialogs: true,
      stickyAuth: true,
      biometricOnly: true,
    );
  }
}
