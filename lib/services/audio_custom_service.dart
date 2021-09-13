import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'audio_background.dart';

/// A singleton class to controll the entire audio session
/// in the foreground and the background.
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
    _audioPlayer.setVolume(0.5);

    AudioSession.instance.then((session)async{
      await session.configure(AudioSessionConfiguration.music());
    });
  }

  late AudioPlayer _audioPlayer;
  late AudioHandler _audioHandler;

  Future<void> setFile(String file) async {
    await _audioPlayer.setFilePath(file);
  }

  Future<void> initService() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(_audioPlayer),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
        androidNotificationChannelName: 'Music playback',
      ),
    );
  }

  /// [isNewSong] referencess whereas you're trying to play
  /// a paused song or if you wanna play a new one. [index]
  /// is the position of your song in the playlist
  Future<void> play({bool isNewSong=true, int index = 0}) async {
    if(isNewSong) {await _audioPlayer.seek(Duration(seconds: 0), index: index);}
    _audioHandler.play();
  }

  Future<void> pause() async {
    // await _audioPlayer.pause();
    await _audioHandler.pause();
  }

  /// [audios] will be the list of songs you wanna loop over.
  /// You can't assign songs individually due the way this media player
  /// is built, if you wanna do so, you should create a new [audios] list
  /// with only one element, the one you wanna play
  Future<void> generatePlaylist(List<AudioSource> audios, [bool updateBackground = false]) async {
    
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audios,
      ),      
      initialIndex: 0,
      preload: true,
      initialPosition: Duration(seconds: 0)
    );

    if(updateBackground) {
      handler.updateMediaItem(
        _audioPlayer.audioSource!.sequence[0].tag as MediaItem
      );  
    }  
  }

  /// This will update the current plyalist based on the
  /// [audios] you provide and will play the song at the
  /// [initialIndex] position with the [position] duration.
  /// If no [position] is provided then it will use the
  /// duration of the current song that's playing.
  Future<void> updatePlaylist(
    List<SongModel> audios, 
    int initialIndex,
    {Duration? position}
  ) async {

    final initialPos = position ??_audioPlayer.position;

    List<AudioSource> playlist = List<AudioSource>.from(audios.map((SongModel e){
        return AudioSource.uri(Uri.parse(e.data));
    }));

    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: playlist
      ),
      initialIndex: initialIndex,
      initialPosition: initialPos
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
  AudioHandler get handler => _audioHandler;
  Stream<PlayerState> get stateStream => _audioPlayer.playerStateStream;

}
