import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  
  static UserPreferences? _instance;

  factory UserPreferences() {
    if(_instance == null) {
      _instance = new UserPreferences._();
    }

    return _instance!;
  }

  UserPreferences._();

  SharedPreferences? _userPrefs;

  StreamController<String> _lanStream = new StreamController.broadcast();

  dispose() {
    _lanStream.close();
  }

  Stream<String> get lanStream => _lanStream.stream;
  Function(String) get lanSink => _lanStream.sink.add;

  Future<void> initPreferences() async {
    _userPrefs = await SharedPreferences.getInstance();

    lanSink(language);
  }

  /// This will return the language prefix, for example, it will return
  /// 'en' for English language
  String get language => _userPrefs?.getString("lan") ?? "en";

  set language(String lan) {
    _userPrefs?.setString("lan", lan);
    lanSink(lan);
  }
}