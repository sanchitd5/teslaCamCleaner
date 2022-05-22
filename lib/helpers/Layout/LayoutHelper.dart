import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../models/models.dart';

class LayoutHelper {
  static final LayoutHelper _instance = LayoutHelper._privateConstructor();
  LayoutHelper._privateConstructor() {
    debugPrint("LayoutHelper initilised.");
  }
  factory LayoutHelper() => _instance;

  // true if platform is Web
  bool get isWeb => kIsWeb;

  // returns the screen size based on the shortest side
  ScreenSize getScreenSize(BuildContext context) {
    if (MediaQuery.of(context).size.shortestSide < 400) return ScreenSize.XS;
    if (MediaQuery.of(context).size.shortestSide < 600) return ScreenSize.SM;
    if (MediaQuery.of(context).size.shortestSide < 786) return ScreenSize.MD;
    if (MediaQuery.of(context).size.shortestSide < 1200) return ScreenSize.LG;
    return ScreenSize.XL;
  }

  // true if device is in tablet mode
  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide > 700;

  // true if device is in desktop mode
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide > 1200;
}
