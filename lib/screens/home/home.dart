import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/providers.dart';

class Home extends StatelessWidget {
  static const String route = '/home';

  const Home({Key? key}) : super(key: key);

  //title Widget for the appbar
  Widget _title(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'flutter',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: 'base',
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
            TextSpan(
              text: 'plate',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(context),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () =>
                Provider.of<UserStateProvider>(context, listen: false)
                    .logout(context),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Builder(builder: (context) {
                String? accessToken =
                    Provider.of<UserStateProvider>(context).accessToken;
                return Text(
                  accessToken != null
                      ? 'accessToken: $accessToken'
                      : 'No Token Found',
                  style: Theme.of(context).textTheme.bodyText1,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
