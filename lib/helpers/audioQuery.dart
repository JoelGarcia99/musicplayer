import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioCustomQuery {

  static List<SongModel> queryedAudios = [];
  static List<ArtistModel> queryedArtist = [];
  static List<AlbumModel> queryedAlbums = [];
  static Map<String, int> musicDataindex  = new Map<String, int>();

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
  Future<List<ArtistModel>> queryArtists([withLoader = false, cache=true]) async {
    
    if(cache && queryedArtist.isNotEmpty) return queryedArtist;

    if(withLoader) {
      SmartDialog.showLoading(
        msg: "Searching for artists",
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
  Future<List<SongModel>> quearyAudios([withLoader = true]) async {

    if(withLoader) {
      SmartDialog.showLoading(
        msg: "Searching for music",
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
        return AudioSource.uri(Uri.parse(e.data));
    }));

    queryedAudios.clear();
    queryedAudios.addAll(audios);

    // by default you will get a playlist where all the songs are in.
    await PlayerController().generatePlaylist(playlist);

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
}
