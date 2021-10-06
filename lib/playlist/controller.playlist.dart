part of 'screen.all_playlists.dart';

class PlaylistController {

  // It's  a list of only one boolean since this class doesn't
  // allow you to keep mutable values, so the only way to mutate
  // this boolean value is through an array
  final isInitialized = [false];
  late final BuildContext _context;
  late final Function? _setState;

  void initController({required BuildContext context, Function? setState}) {
    if(!isInitialized.first) {
      this._context = context;
      this._setState = setState;

      isInitialized.clear();
      isInitialized.add(true);
    }
  }

  static final List<PlaylistModel> _playlists = [];
  static final List<audioQuery.SongModel> _songs = [];

  /// Async programming features
  final _playlistsStreamController = new StreamController<List<PlaylistModel>>.broadcast();
  final _songStreamController = new StreamController<List<audioQuery.SongModel>>.broadcast();

  disposeController() {
    _playlistsStreamController.close();
    _songStreamController.close();
  }

  /// Async getters & setters
  set playlistSink(List<PlaylistModel> data) => _playlistsStreamController.sink.add(data);
  Stream<List<PlaylistModel>> get playlistStream => _playlistsStreamController.stream;
  List<PlaylistModel> get currentPlaylistStreamValue => _playlists;

  set songSink(List<audioQuery.SongModel> data) => _songStreamController.sink.add(data);
  Stream<List<audioQuery.SongModel>> get songStream => _songStreamController.stream;
  List<audioQuery.SongModel> get currentSongsStreamValue => _songs;

  final LocalDatabase _db = LocalDatabase();

  /// Queries playlists stored locally on the device. You can
  /// use [currentPlaylistStreamValue] if you want to avoid
  /// using async computing or the return value of this method
  Future<List<PlaylistModel>> queryPlaylists([bool cache = true]) async {

    if(!cache || _playlists.isEmpty) {
      final queriedPlaylist = await _db.queryPlaylists();
      _playlists.addAll(queriedPlaylist);
      playlistSink = _playlists;
    }

    return _playlists;
  }

  /// Creates a new playlists and pushes it into [playlistStream] 
  /// and updates [currentPlaylistStreamValue]
  Future<bool> createPlaylist(PlaylistModel playlist) async {
    if(await _db.createPlaylist(playlist)) {
      _playlists.add(playlist);
      _playlists.sort((a, b) => a.name.compareTo(b.name));

      playlistSink = _playlists;

      return true;
    }

    return false;
  }

  /// Deletes a playlist physically based on an [id]. It does not
  /// remove N-N referencess, but don't worry, those references 
  /// does not require too much space.
  Future<bool> deletePlaylist(String id) async {

    SmartDialog.showLoading();
    if(!(await _db.deletePlaylist(id))) return false;

    _playlists.removeWhere((element) => element.id == id);
    playlistSink = _playlists;    
    SmartDialog.dismiss();    

    SmartDialog.showToast(
      S.of(_context).playlist_was_deleted,
      time: Duration(seconds: 2)
    );

    if(_setState != null) {
      _setState!((){});
    }

    return true;
  }

  /// Returns a list of songs that match with [playlistID]
  Future<List<audioQuery.SongModel>> querySongsByPlaylist(String playlistID) async {
    
    final List<Map<String, Object?>> response = await _db.queryPlaylistById(playlistID);

    final songList = await audioQuery.OnAudioQuery().querySongsBy(
      audioQuery.SongsByType.ID,
      List<Object>.from(response.map((e) => e['music_id']))
    );

    _songs.clear();
    _songs.addAll(songList);
    songSink = _songs;

    return songList;
  }


  Future addSongsToPlaylist(String playlistID, List<int> songsID) async {
    await _db.insertSongsInPlaylist(playlistID, songsID);

    final idsSet = songsID.toSet();
    _songs.clear();
    _songs.addAll(AudioCustomQuery.queryedAudios.where((element) => idsSet.contains(element.id)));
    songSink = _songs;
  }

  void showPlaylistCreationDialog() {

    final formKey = new GlobalKey<FormState>();
    final titleController = new TextEditingController();
    final descrController = new TextEditingController();

    showDialog(
      context: _context, 
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    helperText: S.of(context).write_playlist_name
                  ),
                  validator: (text) {

                    if(text != null) {
                      final splitted = text.split(" ");
                      splitted.forEach((element) {element.trim();});

                      text = splitted.join(" ");
                    }

                    if((text?.isEmpty ?? true) || text?.length == 0) {
                      return S.of(context).enter_valid_name;
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: descrController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    helperText: S.of(context).write_playlist_about
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              label: Text(S.of(context).cancel),
              icon: Icon(Icons.cancel),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton.icon(
              onPressed: (){
                if(formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();

                  createPlaylist(new PlaylistModel(
                    name: titleController.text,
                    description: descrController.text,
                    creationDate: DateTime.now().millisecond.toString(),
                    elementsOnPlaylist: 0
                  )).then((success)async{
                    if(success) {
                      Navigator.of(context).pop();
                      SmartDialog.showToast(S.of(context).playlist_created);
                      if(_setState != null) _setState!(() {});
                    }
                  });
                }
                else {
                  SmartDialog.showToast(
                    S.of(context).enter_valid_name,
                    time: Duration(seconds: 1)
                  );
                }
              }, 
              icon: Icon(Icons.save), 
              label: Text(S.of(context).save)
            ),
          ],
        );
      }, 
    );
  }
}