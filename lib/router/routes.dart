import 'package:flutter/material.dart';
import 'package:musicplayer/player/MainScreen.dart';
import 'package:musicplayer/settings/SettingsMainScreen.dart';

class Routes {
  static const String SETTINGS = '/settings';
  static const String HOME = '/home';
}

Map<String, Widget Function(BuildContext)> buildRoutes() => {
  Routes.HOME: (_)=> MainPlayerScreen(),
  Routes.SETTINGS: (_)=> SettingsMainScreen()
};