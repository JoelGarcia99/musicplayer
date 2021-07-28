
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
  }

  late final AudioPlayer _audioPlayer;

  Future<void> setFile(String file) async {
    await _audioPlayer.stop();
    await _audioPlayer.setFilePath(file);
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> generatePlaylist(List<AudioSource> audios) async {
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audios
      )      
    );
  }


  AudioPlayer get player => _audioPlayer;
  Stream<PlayerState> get stateStream => _audioPlayer.playerStateStream;

}