import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import '../group_list/group_list_view.dart';

/// Displays a list of CardItems.
class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isMasterPass = true;
  final TextEditingController _masterPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    isMasterPass = await AuthService.instance.getMasterPass != null;
    if (isMasterPass) {
      try {
        AuthService.instance.setAuthenticated =
            await AuthService.instance.authenticate();

        if (AuthService.instance.isAuthenticated) {
          Navigator.pushReplacementNamed(
            context,
            GroupListView.routeName,
          );
        } else {
          displayLockedDialog();
        }
      } catch (e) {
        displayErrorDialog();
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: isMasterPass
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/logo-android.png',
                      scale: 10,
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
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30.0),
                      const Text(
                        'Setup Master Password',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Icon(
                          Icons.security,
                          color: CupertinoColors.inactiveGray,
                          size: 80.0,
                        ),
                      ),
                      const Text(
                        'Create a strong Master Password that will protect all your data stored in Card Box.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        height: 130.0,
                        child: Column(
                          children: [
                            const Text(
                              'Password must contain:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            GridView.count(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              childAspectRatio: 5.0,
                              physics: const NeverScrollableScrollPhysics(),
                              children: const [
                                PasswordCriteria(label: 'One uppercase'),
                                PasswordCriteria(label: 'One lowercase'),
                                PasswordCriteria(label: 'One number'),
                                PasswordCriteria(
                                    label: 'One special character'),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            const PasswordCriteria(
                              label: 'Must be atleast 8 characters',
                              center: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      CupertinoFormSection(
                        children: [
                          CupertinoFormRow(
                            child: CupertinoTextFormFieldRow(
                              obscureText: true,
                              padding: EdgeInsets.zero,
                              controller: _masterPassController,
                              placeholder: 'Master Passsord',
                              keyboardType: TextInputType.text,
                              prefix: const Icon(Icons.lock_outline),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              autocorrect: false,
                              validator: (String? value) {
                                String pattern =
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                RegExp regex = RegExp(pattern);
                                if (value!.isEmpty) {
                                  return 'Please enter Master Password';
                                } else {
                                  if (!regex.hasMatch(value)) {
                                    return 'Enter valid Master Password';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await AuthService.instance
                                .setMasterPass(_masterPassController.text);
                            Navigator.pushReplacementNamed(
                              context,
                              GroupListView.routeName,
                            );
                          }
                        },
                      ),
                    ],
                  ),
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

  void displayErrorDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Authentication Error"),
        content: const Text(
            "For your security, Card Box can only be used with Biometric Authentication. Please setup Biometrics and try again."),
        actions: [
          CupertinoDialogAction(
            child: const Text("Try again"),
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

class PasswordCriteria extends StatelessWidget {
  const PasswordCriteria({
    Key? key,
    required this.label,
    this.center = false,
  }) : super(key: key);

  final String label;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.add_moderator_outlined,
          color: CupertinoColors.systemGreen,
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.inactiveGray,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
