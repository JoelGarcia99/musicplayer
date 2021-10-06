import 'package:flutter/material.dart';
import 'package:musicplayer/downloader/youtube/YouTubeScreen.dart';
import 'package:musicplayer/player/screen.player.dart';
import 'package:musicplayer/player/screen.music_list.dart';
import 'package:musicplayer/playlist/screen.all_playlists.dart';
import 'package:musicplayer/playlist/screen.playlist.dart';
import 'package:musicplayer/settings/SettingsMainScreen.dart';

class Routes {
  static const String SETTINGS = '/settings';
  static const String HOME = '/home';
  static const String MUSIC_LIST = '/music/list';
  static const String SINGERS_LIST = '/singers/list';
  static const String YOUTUBE_DOWNLOADER = '/downloader/youtube';
  static const String SINGERS_ALBUMS = '/singers/album';
  static const String PLAYLISTS = '/playlists';
  static const String PLAYLIST_X = '/playlists/x';
}

Map<String, Widget Function(BuildContext)> buildRoutes() => {
  Routes.HOME: (_)=> MainPlayerScreen(),
  Routes.SETTINGS: (_)=> SettingsMainScreen(),
  Routes.MUSIC_LIST: (_) => MusicListWidget(),
  Routes.PLAYLIST_X: (_) => PlaylistScreen(),
  Routes.PLAYLISTS: (_) => PlaylistMainScreen(),
  Routes.YOUTUBE_DOWNLOADER: (_) => YouTubeScreen(),
};
