import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationTheme {
  ThemeData? _theme;
  bool useDarkMode = false;

  ApplicationTheme(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextTheme googleTextTheme =
        GoogleFonts.openSansTextTheme(textTheme).copyWith(
      bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
    );

    final ThemeData baseTheme =
        useDarkMode ? ThemeData.dark() : ThemeData.light();

    _theme = baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: Colors.white,
        secondary: Colors.blueAccent,
      ),
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 1,
        color: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: googleTextTheme.headline6,
        toolbarTextStyle: googleTextTheme.headline5,
      ),
      primaryTextTheme: TextTheme(
        headline6: ThemeData.light().primaryTextTheme.headline6!.copyWith(
              color: Colors.black,
            ),
      ),
    );
  }

  ThemeData? get getAppTheme => _theme;
}
