import 'dart:ui';

import 'package:flutter/material.dart';

class AppThemeData {

  static AppThemeData? _instance;

  factory AppThemeData() {
    if(_instance == null) {
      _instance = new AppThemeData._();
    }

    return _instance!;
  }

  AppThemeData._();

  Widget getBackgroundColor(Size size) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        width: double.infinity,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget getBackgroundImage(Size size) {
    return Container(
      width: double.infinity,
      height: size.height,
      child: Image(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }


  final Color iconColor = new Color(0xffD9D9D9);
  final Color appbarColor = new Color(0xffD9D9D9);
  final Color cardColor = new Color(0xffD9D9D9);
  final Color focusCardColo = new Color(0xffF3FEB0);

}