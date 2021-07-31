part of 'music_bloc.dart';

@immutable
abstract class MusicEvent {}

class AddSongs extends MusicEvent {
  late final MusicInitial songsState;

  AddSongs({required List<SongModel> songs}) {
    songsState = new MusicInitial(songs);
  }
}

class AddCurrent extends MusicEvent {
  late final SongModel song;
  late final bool isRunning;

  AddCurrent({required SongModel song}) {
    this.song = song;
    isRunning = true;
  }
}

class PausePlayCurrent extends MusicEvent {
  final bool isRunning;

  PausePlayCurrent({required this.isRunning});
}
