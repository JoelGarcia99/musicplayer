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
    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        color: backgroundColor
      ),
    );
    
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //   child: Container(
    //     width: double.infinity,
    //     height: size.height,
    //     decoration: BoxDecoration(
    //       color: Colors.black.withOpacity(0.6),
    //     ),
    //   ),
    // );
  }

  Widget getBackgroundImage(Size size) {
    return Container();
    // return Container(
    //   width: double.infinity,
    //   height: size.height,
    //   child: Image(
    //     image: AssetImage("assets/images/background.jpg"),
    //     fit: BoxFit.cover,
    //   ),
    // );
  }

  /////////////////////// Colors //////////////////////////
  final Color primaryDark = Colors.black;
  final Color backgroundColor = new Color(0xff3D3D3D);
  
  final Color iconColor = new Color(0xffD9D9D9);
  final Color appbarColor = new Color(0xffD9D9D9);
  final Color cardColor = new Color(0xffD9D9D9);
  final Color focusCardColo = new Color(0xffF3FEB0);
  final Color textColor = Colors.white;
  final Color textFocusColor = Colors.black;
  
  final Color textLightColor = Colors.black;

  /////////////////// Borders ////////////////////////
  final double bottomSheetTopBorders = 25.0;
  final double initialBottomSheetSize = 0.08;
  final double finalBottomSheetSize = 0.8;

}