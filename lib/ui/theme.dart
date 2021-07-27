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

  final Color iconColor = new Color(0xffD9D9D9);
  final Color cardColor = new Color(0xffA6A6A6);

}