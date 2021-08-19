import 'package:flutter/material.dart';
import 'package:musicplayer/downloader/youtube/YouTubeScreen.dart';
import 'package:musicplayer/player/MainScreen.dart';
import 'package:musicplayer/player/MusicListScreen.dart';
import 'package:musicplayer/settings/SettingsMainScreen.dart';
import 'package:musicplayer/singers%20module/SingersScreen.dart';
import 'package:musicplayer/singers%20module/view.singerAlbums.dart';

class Routes {
  static const String SETTINGS = '/settings';
  static const String HOME = '/home';
  static const String MUSIC_LIST = '/music/list';
  static const String SINGERS_LIST = '/singers/list';
  static const String YOUTUBE_DOWNLOADER = '/downloader/youtube';
  static const String SINGERS_ALBUMS = '/singers/album';
}

Map<String, Widget Function(BuildContext)> buildRoutes() => {
  Routes.HOME: (_)=> MainPlayerScreen(),
  Routes.SETTINGS: (_)=> SettingsMainScreen(),
  Routes.MUSIC_LIST: (_) => MusicListWidget(),
  Routes.SINGERS_LIST: (_) => SingersScreen(),
  Routes.YOUTUBE_DOWNLOADER: (_) => YouTubeScreen(),
  Routes.SINGERS_ALBUMS: (_) => SingerAlbums()
};
