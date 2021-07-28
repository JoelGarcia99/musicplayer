part of 'music_bloc.dart';

@immutable
abstract class MusicState {
  final List<SongModel> songs;
  MusicState(this.songs);
}

@immutable
class MusicInitial extends MusicState {
  MusicInitial([List<SongModel>? songs]):super(songs ?? []);
}

/// This will handle the state when you have selected
/// a song from the 
@immutable
class MusicWithSelection extends MusicState {
  late final SongModel current;
  late final bool isRunning;

  MusicWithSelection({
    required SongModel currentSong, 
    required List<SongModel> songs,
    bool isRunning = true
  }):super(songs){
    this.current = currentSong;
    this.isRunning = isRunning;
  }

  MusicWithSelection copyWith({
    SongModel? currentSong, 
    List<SongModel>? songs,
    bool? isRunning
  }) {
    return new MusicWithSelection(
      currentSong: currentSong ?? this.current,
      songs: songs ?? this.songs,
      isRunning: isRunning ?? this.isRunning
    );
  }
}
