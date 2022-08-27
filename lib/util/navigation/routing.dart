import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///App Navigation Methods
class Routing {
  ///Simple Side Route
  static void sideRoute({
    required BuildContext context,
    required Widget newPage,
  }) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => newPage));
  }
}
