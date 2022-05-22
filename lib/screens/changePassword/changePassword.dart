import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ChangePassword extends StatelessWidget {
  static const String route = '/changePassword';

  const ChangePassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 50,
          ),
          child: ChangePasswordForm(),
        ),
      ),
    );
  }
}
