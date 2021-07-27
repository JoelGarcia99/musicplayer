part of 'music_bloc.dart';

@immutable
abstract class MusicEvent {}

class AddSongs extends MusicEvent {
  late final MusicInitial songsState;

  AddSongs({required List<SongModel> songs}) {
    songsState = new MusicInitial(songs);
  }
}
