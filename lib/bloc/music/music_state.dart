part of 'music_bloc.dart';

@immutable
abstract class MusicState {}

@immutable
class MusicInitial extends MusicState {
  late final List<SongModel> songs;

  MusicInitial([List<SongModel>? songs]) {
    this.songs = songs ?? [];
  }
}
