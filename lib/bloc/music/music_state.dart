part of 'music_bloc.dart';

@immutable
abstract class MusicState {
}

@immutable
class MusicInitial extends MusicState {
}

/// This will handle the state when you have selected
/// a song from the 
@immutable
class MusicWithSelection extends MusicState {
  late final SongModel current;
  late final bool isRunning;

  MusicWithSelection({
    required SongModel currentSong,
    bool isRunning = true
  }){
    this.current = currentSong;
    this.isRunning = isRunning;
  }

  MusicWithSelection copyWith({
    SongModel? currentSong, 
    bool? isRunning
  }) {
    return new MusicWithSelection(
      currentSong: currentSong ?? this.current,
      isRunning: isRunning ?? this.isRunning
    );
  }
}
