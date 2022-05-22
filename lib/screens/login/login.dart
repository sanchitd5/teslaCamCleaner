import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class Login extends StatelessWidget {
  static const String route = '/login';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Login({Key? key}) : super(key: key);

  double getFormWidth(context) {
    if (MediaQuery.of(context).size.width > 1200) {
      return MediaQuery.of(context).size.width / 4;
    }
    if (MediaQuery.of(context).size.width > 786) {
      return MediaQuery.of(context).size.width / 3;
    }
    if (MediaQuery.of(context).size.width > 600) {
      return MediaQuery.of(context).size.width / 2;
    }
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    Widget _backButton() {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child:
                    const Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              const Text('Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (MediaQuery.of(context).size.width < 786)
              Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: const BezierContainer(),
              ),
            Container(
              width: getFormWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: LoginForm(
                  formKey: _formKey,
                  height: height,
                ),
              ),
            ),
            Positioned(top: 60, left: 10, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
