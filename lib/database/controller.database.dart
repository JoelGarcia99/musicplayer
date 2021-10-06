import 'package:musicplayer/database/helper.database.dart';
import 'package:musicplayer/playlist/model.playlist.dart';
import 'package:sqflite/sqflite.dart';

/// A sigleton database helper to access local data like
/// playlist, favorites, etc. To use this class you need
/// to call [init] method first
class LocalDatabase {

  static LocalDatabase? _instance;
  static const int DB_VERSION = 1;

  factory LocalDatabase() {
    if(_instance == null) {
      _instance = new LocalDatabase._();
    }

    return _instance!;
  }

  LocalDatabase._();

  late final Database _db;

  /// You need to call this method before using any [_db]
  /// option
  Future<void> init({String dbPath = "devall.player_data.db"}) async {
    _db = await openDatabase(
      dbPath,
      version: DB_VERSION,
      onCreate: (db, version) async {
        final queries = await DatabaseHelper().formatSQLQuery("assets/database/database.sql");

        await db.transaction((txn)async{
          final batch = txn.batch();

          queries.forEach((query) {
            batch.execute(query.trim());
          });

          await batch.commit(continueOnError: false);
        });
      },
      singleInstance: true
    );
  }

  /// Query all the playlists on the device and show how many musics
  /// does it have
  Future<List<PlaylistModel>> queryPlaylists([bool cache = true]) async {
    final playlistSet = await _db.rawQuery(
      "select p.__id, p.name, p.description, p.creation_date,"
      "count(mip.playlist_id) as song_count from playlist as p "
      "left join musicinplaylist as mip on(p.__id = mip.playlist_id) "
      "group by p.__id order by p.name asc;"
    );

    return List<PlaylistModel>.from(playlistSet.map((playlist){
      return PlaylistModel.fromJson(playlist);
    }));
  }

  /// Creates a playlist based on [playlist] metadata. The [playlist.id]
  /// should be generated before passing it to sqlite 'cause it's
  /// required
  Future<bool> createPlaylist(PlaylistModel playlist) async {
    final query = await _db.rawInsert(
      "insert into playlist values"
      "(?, ?, ?, ?, null);",
      [
        playlist.id, playlist.name.toLowerCase(), playlist.description.toLowerCase(), 
        playlist.creationDate
      ]
    );

    return query > 0;
  }


  /// Permanently delete a playlist that match with [id].
  /// The playlist itself is gonna be removed physically 
  /// but its relationships are not, so you could recover
  /// it in the future with another name and description
  Future<bool> deletePlaylist(String id) async {
    final response = await _db.rawDelete(
      "DELETE FROM playlist WHERE __id = ?",
      [id]
    );

    // if [response] is grather tha 0 it means there
    // was any row affected
    return response > 0;
  }

  /// Query all the music present in the playlist with id [playlistID].
  /// You still need to query songs on your device since this method just
  /// give you the IDs but not the song model itself. 
  /// the [response] list contains two IDs: *__id* and *local_id*.
  /// The *__id* is used only for SQL but if you need to query songs
  /// on your device you should use *local_id*.
  Future<List<Map<String, Object?>>> queryPlaylistById(String playlistID) async {
    final response = await _db.rawQuery(
      "select * from MusicInPlaylist "
      "where playlist_id = ?",
      [playlistID]
    );

    return response;
  }

  Future<bool> insertSongsInPlaylist(String playlistID, List<int> songsID) async {
    songsID.forEach((musicID) async {

      await _db.rawDelete("delete from musicInPlaylist where playlist_id = ?", [playlistID]);

      await _db.rawInsert(
        "insert into MusicInPlaylist values(?, ?);",
        [musicID.toString(), playlistID]
      );
    });

    return true;
  }

  Database get database => _db;
}