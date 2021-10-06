import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/services/controller.audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

/// Singleton class to query local audios
class AudioCustomQuery {
  static AudioCustomQuery? _instance;

  factory AudioCustomQuery() {
    if(_instance == null ){
      _instance = new AudioCustomQuery._();
    }

    return _instance!;
  }

  AudioCustomQuery._();

  
  static List<SongModel> queryedAudios = [];
  static List<ArtistModel> queryedArtist = [];
  static List<AlbumModel> queryedAlbums = [];
  static List<PlaylistModel> queryedPlaylists = [];
  static Map<String, int> musicDataindex  = new Map<String, int>();

  StreamController<List<SongModel>> _songStream = new StreamController.broadcast();

  Stream<List<SongModel>> get songStream => _songStream.stream;
  Function(List<SongModel>) get songSink => _songStream.sink.add;


  dispose() {
    _songStream.close();
  }

  /// Search albums all along your devices. If [shouldRefresh] is
  /// false then you will use albums that are already in your RAM,
  /// otherwise you will rescan your device. 
  /// If [singer] is provided then you'll search only for albums that
  /// belong to him.
  Future<List<AlbumModel>> queryAlbums({bool shouldRefresh = false, String? singer}) async {

    if(shouldRefresh || queryedAlbums.isEmpty) {
      queryedAlbums = await OnAudioQuery().queryAlbums();
    }

    if(singer != null) {
      return queryedAlbums.where((element) => element.artist == singer).toList();
    }

    return queryedAlbums;
  }

  /// Search artists all along your devices. If [withLoader] is
  /// true then a loader modal sheet is triggered and will
  /// interrupt all user interaction until your devices is scaned
  /// for new artists. [cache] will save you extra work and will use
  /// the artitst that already has been scanned in your device.
  Future<List<ArtistModel>> queryArtists([withLoader = false, cache=true, message='']) async {
    
    if(cache && queryedArtist.isNotEmpty) return queryedArtist;

    if(withLoader) {
      SmartDialog.showLoading(
        msg: message,
      );
    }

    List<ArtistModel> artists = await OnAudioQuery().queryArtists(
      ArtistSortType.ARTIST_NAME,
      OrderType.ASC_OR_SMALLER,
      UriType.EXTERNAL,
      true
    );

    queryedArtist.clear();
    queryedArtist.addAll(artists);

    return queryedArtist;
  }

  /// Search audios all along your devices. If [withLoader] is
  /// true then a loader modal sheet is triggered and will
  /// interrupt all user interaction until your devices is scaned
  /// for new songs
  Future<List<SongModel>> quearyAudios([withLoader = true, message = '', updateBackground = false]) async {

    if(withLoader) {
      SmartDialog.showLoading(
        msg: message,
      );
    }

    List<SongModel> audios = await OnAudioQuery().querySongs(
      SongSortType.DISPLAY_NAME,
      OrderType.ASC_OR_SMALLER,
      UriType.EXTERNAL,
      true
    );

    audios = audios.where((element) => element.size >= 1000000).toList();
    generateDataIndex(audios);

    if(withLoader) {
      await SmartDialog.dismiss();
      await SmartDialog.showToast(audios.isEmpty? "There are no audios":"Music loaded");
    }

    final List<AudioSource> playlist = List<AudioSource>.from(audios.map((SongModel e){
        return AudioSource.uri(
          Uri.parse(e.data),
          tag: MediaItem(
            id: e.id.toString(), 
            title: e.title,
            album: e.album,
            artist: e.artist,
            duration: Duration(milliseconds: e.duration),
            artUri: e.artwork == null? null:Uri.parse(e.artwork!),
          )
        );
    }));

    queryedAudios.clear();
    queryedAudios.addAll(audios);

    // by default you will get a playlist where all the songs are in.
    await PlayerController().generatePlaylist(playlist, updateBackground);

    songSink(queryedAudios);
    return audios;
  }

  /// Since sometimes you need to access to a music index
  /// in a playlist based on its name, [musicDataindex] is
  /// created so you pass the music name and it will return
  /// its index. Remeber that this will update the playlist
  /// that is currently playing but not the actual list of
  /// all songs. if no [songs] list is provided, then it will
  /// use queryed audios.  
  void generateDataIndex([List<SongModel>? songs]) {
    
    final audios = songs ?? queryedAudios;
    
    for(int i=0; i<audios.length; ++i) {
      musicDataindex[audios[i].data] = i;
    }
  }

  /// Query local playlists on your device. If [forceSearch] is set to
  /// true then this will query again your device for music and no matter
  /// if there is cache
  Future<List<PlaylistModel>> queryPlaylist([bool forceSearch = false]) async {

    /// If there is already data about playlists then you can
    /// avoid searching
    if(!forceSearch && queryedPlaylists.isNotEmpty) {
      return queryedPlaylists;
    }

    final playlists = await OnAudioQuery().queryPlaylists(
      PlaylistSortType.PLAYLIST_NAME,
      OrderType.ASC_OR_SMALLER,
      null, 
      true // request permissions
    );

    queryedPlaylists.clear();
    queryedPlaylists.addAll(playlists);

    return playlists;
  }

  Future<List<SongModel>> queryMusicByPlaylist(int playlistID) async {
    final musics = await OnAudioQuery().queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      playlistID
    );

    return musics;
  }

  Future<bool> createPlaylist(String name) async {
    final response = await OnAudioQuery().createPlaylist(name);

    return response;
  }

  Future<bool> removePlaylist(int id) async {
    return await OnAudioQuery().removePlaylist(id);
  }

  Future<bool> editPlaylistName(int id, String newName) async {
    final success = await OnAudioQuery().renamePlaylist(id, newName, true);

    if(success) {
      final index = AudioCustomQuery.queryedPlaylists.indexWhere((element) {
        return element.id == id;
      });

      final currentModel = AudioCustomQuery.queryedPlaylists[index];

      AudioCustomQuery.queryedPlaylists.replaceRange(
        index, 
        index,
        [
          new PlaylistModel({
            "_id": currentModel.id,
            "name": currentModel.playlistName,
            "_data": currentModel.data,
            "date_added": currentModel.dateAdded,
            "date_modified": currentModel.dateModified,
          })
        ]
      );
    }

    return success;
  }
}
