import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_onboarding/routes/helpers/parentRouter.dart';

import '../../constants/constants.dart';
import '../../helpers/helpers.dart';

class WelcomePage extends StatefulWidget {
  static String route = '/welcome';
  WelcomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  final LayoutHelper _layoutHelper = LayoutHelper();

  double getButtonSize(context) {
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

  Widget _loginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/login');
      },
      child: Container(
        width: getButtonSize(context),
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xffdf8e33).withAlpha(100),
                  offset: const Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'flutter',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: const [
            TextSpan(
              text: 'base',
              style: TextStyle(color: Colors.white70, fontSize: 30),
            ),
            TextSpan(
              text: 'plate',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _authorText() {
    double _fontSize = _layoutHelper.isTablet(context) ? 15 : 20;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Developed',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline1,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
                children: [
                  TextSpan(
                    text: ' By ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: _fontSize,
                    ),
                  ),
                ]),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            Constants.applicationConstants.copyright,
            style: GoogleFonts.abhayaLibre(
              textStyle: Theme.of(context).textTheme.caption,
              fontSize: _fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _loginButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ],
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _title(),
              const SizedBox(
                height: 80,
              ),
              _buttons(context),
              const SizedBox(
                height: 20,
              ),
              _authorText(),
            ],
          ),
        ),
      ),
    );
  }
}
