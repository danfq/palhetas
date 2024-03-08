import 'package:flutter/material.dart';
import 'package:palhetas/util/anim/handler.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimationsHandler.asset(animation: "no_connection"),
        ),
      ),
    );
  }
}
