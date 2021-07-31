import 'package:just_audio/just_audio.dart';

class PlayerController {

  static PlayerController? _instance;

  factory PlayerController() {
    if(_instance == null) {
      _instance = new PlayerController._();
    }
    
    return _instance!;
  }

  PlayerController._() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setLoopMode(LoopMode.all);
  }

  late AudioPlayer _audioPlayer;

  Future<void> setFile(String file) async {
    await _audioPlayer.setFilePath(file);
  }

  /// [isNewSong] referencess whereas you're trying to play
  /// a paused song or if you wanna play a new one. [index]
  /// is the position of your song in the playlist
  Future<void> play({bool isNewSong=true, int index = 0}) async {
    await _audioPlayer.stop();
    if(isNewSong) {await _audioPlayer.seek(Duration(seconds: 0), index: index);}
    _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// [audios] will be the list of songs you wanna loop over.
  /// You can't assign songs individually due the way this media player
  /// is built, if you wanna do so, you should create a new [audios] list
  /// with only one element, the one you wanna play
  Future<void> generatePlaylist(List<AudioSource> audios) async {
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audios
      ),      
      initialIndex: 0,
      initialPosition: Duration(seconds: 0)
    );
  }

  /// This method is to handle music changing actions
  /// like skip next or previous. [callback] is what you 
  /// wanna do when the index change
  void onMusicSkip(Function(int) callback) {

    _audioPlayer.currentIndexStream.listen((int? index) {  
      if(index != null) {
        callback(index);
      }
    });

  }


  AudioPlayer get player => _audioPlayer;
  Stream<PlayerState> get stateStream => _audioPlayer.playerStateStream;

}