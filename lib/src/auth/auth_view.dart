import 'package:cardbox/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../cards_list/cards_list_view.dart';

/// Displays a list of CardItems.
class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    try {
      AuthService.instance.setAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: canCheckBiometrics,
      );
    } on PlatformException catch (e) {
      print(e);
      return;
    }

    if (AuthService.instance.isAuthenticated) {
      Navigator.pushReplacementNamed(
        context,
        CardsListView.routeName,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
