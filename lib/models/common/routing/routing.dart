import 'package:flutter/material.dart';
import './../../enums/enums.dart';

class RouteConfig {
  String route;
  RouteType type;
  Widget widget;
  RouteConfig({
    required this.route,
    required this.type,
    required this.widget,
  });
}
