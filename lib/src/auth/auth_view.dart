import 'package:cardbox/src/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../group_list/group_list_view.dart';

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
    try {
      AuthService.instance.setAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (_) {
      return;
    }

    if (AuthService.instance.isAuthenticated) {
      Navigator.pushReplacementNamed(
        context,
        GroupListView.routeName,
      );
    } else {
      displayLockedDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset(
                    'assets/images/logo-android.png',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Card Box',
                  style: TextStyle(
                    fontSize: 34.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayLockedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Card Box is locked"),
        content: const Text(
            "For your security, you can only use Card Box when it's unlocked"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Unlock"),
            onPressed: () {
              Navigator.pop(context);
              _authenticate();
            },
          )
        ],
      ),
    );
  }
}
