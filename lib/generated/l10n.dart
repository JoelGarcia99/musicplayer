// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Add music`
  String get add_music {
    return Intl.message(
      'Add music',
      name: 'add_music',
      desc: '',
      args: [],
    );
  }

  /// `Albums`
  String get albums {
    return Intl.message(
      'Albums',
      name: 'albums',
      desc: '',
      args: [],
    );
  }

  /// `Alert!`
  String get alert {
    return Intl.message(
      'Alert!',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Choose your language`
  String get choose_language {
    return Intl.message(
      'Choose your language',
      name: 'choose_language',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete this playlist?`
  String get confirm_delete_playlist {
    return Intl.message(
      'Are you sure you want to permanently delete this playlist?',
      name: 'confirm_delete_playlist',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Please, enter a valid name`
  String get enter_valid_name {
    return Intl.message(
      'Please, enter a valid name',
      name: 'enter_valid_name',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Your language has been changed. Restart the app to apply the changes`
  String get language_changed {
    return Intl.message(
      'Your language has been changed. Restart the app to apply the changes',
      name: 'language_changed',
      desc: '',
      args: [],
    );
  }

  /// `Searching for musics`
  String get searching_music {
    return Intl.message(
      'Searching for musics',
      name: 'searching_music',
      desc: '',
      args: [],
    );
  }

  /// `Searching for playlists`
  String get searching_playlists {
    return Intl.message(
      'Searching for playlists',
      name: 'searching_playlists',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account`
  String get manage_account {
    return Intl.message(
      'Manage your account',
      name: 'manage_account',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Music list`
  String get music_list {
    return Intl.message(
      'Music list',
      name: 'music_list',
      desc: '',
      args: [],
    );
  }

  /// `Music Player`
  String get music_player {
    return Intl.message(
      'Music Player',
      name: 'music_player',
      desc: '',
      args: [],
    );
  }

  /// `Next in playlist`
  String get next_in_playlist {
    return Intl.message(
      'Next in playlist',
      name: 'next_in_playlist',
      desc: '',
      args: [],
    );
  }

  /// `There is no data to show`
  String get nothing_to_show {
    return Intl.message(
      'There is no data to show',
      name: 'nothing_to_show',
      desc: '',
      args: [],
    );
  }

  /// `Songs:`
  String get number_songs {
    return Intl.message(
      'Songs:',
      name: 'number_songs',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get playlists {
    return Intl.message(
      'Playlists',
      name: 'playlists',
      desc: '',
      args: [],
    );
  }

  /// `Playlist created!`
  String get playlist_created {
    return Intl.message(
      'Playlist created!',
      name: 'playlist_created',
      desc: '',
      args: [],
    );
  }

  /// `The playlist was removed`
  String get playlist_was_deleted {
    return Intl.message(
      'The playlist was removed',
      name: 'playlist_was_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Scan for local music`
  String get scan_local_music {
    return Intl.message(
      'Scan for local music',
      name: 'scan_local_music',
      desc: '',
      args: [],
    );
  }

  /// `Scan for music files in your local storage`
  String get scan_music_in_storage {
    return Intl.message(
      'Scan for music files in your local storage',
      name: 'scan_music_in_storage',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Singers`
  String get singers {
    return Intl.message(
      'Singers',
      name: 'singers',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `There are no items`
  String get there_are_no_items {
    return Intl.message(
      'There are no items',
      name: 'there_are_no_items',
      desc: '',
      args: [],
    );
  }

  /// `Tracks`
  String get tracks {
    return Intl.message(
      'Tracks',
      name: 'tracks',
      desc: '',
      args: [],
    );
  }

  /// `Write the playlist name`
  String get write_playlist_name {
    return Intl.message(
      'Write the playlist name',
      name: 'write_playlist_name',
      desc: '',
      args: [],
    );
  }

  /// `Write the playlist description`
  String get write_playlist_about {
    return Intl.message(
      'Write the playlist description',
      name: 'write_playlist_about',
      desc: '',
      args: [],
    );
  }

  /// `Your current language is`
  String get your_current_lan_is {
    return Intl.message(
      'Your current language is',
      name: 'your_current_lan_is',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
