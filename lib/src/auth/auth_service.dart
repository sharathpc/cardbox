import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final String masterPassKey = 'cardboxmasterpass';
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  static bool _isAuthenticated = false;
  bool get isAuthenticated {
    return _isAuthenticated;
  }

  set setAuthenticated(bool value) {
    _isAuthenticated = value;
  }

  Future<String?> get getMasterPass async {
    return await _storage.read(key: masterPassKey);
  }

  Future<void> setMasterPass(String value) async {
    return await _storage.write(key: masterPassKey, value: value);
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
