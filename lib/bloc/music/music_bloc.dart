import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial());

  @override
  Stream<MusicState> mapEventToState(MusicEvent event) async* {
    
    switch(event.runtimeType) {
      case AddCurrent:
        yield MusicWithSelection(
          currentSong: (event as AddCurrent).song,
          isRunning: true
        );
        break;
      case PausePlayCurrent:
        yield (state as MusicWithSelection).copyWith(
          isRunning: (event as PausePlayCurrent).isRunning
        );
        break;
      default: yield state;
    }
  }
}
