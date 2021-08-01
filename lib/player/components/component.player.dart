import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/player/components/component.songArtWork.dart';
import 'package:musicplayer/ui/theme.dart';

import 'component.progressBar.dart';
import '../controller.player.dart';

class CustomPlayer extends StatelessWidget {

  late final Size containerSize;
  late final MusicBloc bloc;
  final PlayerController controller = new PlayerController();

  @override
  Widget build(BuildContext context) {

    bloc = context.read<MusicBloc>();
    containerSize = MediaQuery.of(context).size;

    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        return Column(
          children: [
            PlayerArtWork(),
            _actionButtons(state),
            if(state is MusicWithSelection) ProgressBar()
          ],
        );
      }
    );
  }

  Widget _actionButtons(MusicState state) {

    bool isCurrent = false;
    final bool isPlaying = (state is MusicWithSelection)? state.isRunning:false;

    if(state is MusicWithSelection) {
      isCurrent = true;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: !isCurrent?null:()async{
            await controller.player.seekToPrevious();
          },
        ),
        IconButton(
          icon: Icon(
            isPlaying? Icons.pause:Icons.play_arrow, 
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: !isCurrent?null:()async {

            // If it's playing, then I wanna pause it
            if(isPlaying) {
              await controller.pause();
            }
            else {
              controller.play(isNewSong: false);
            }

            // updating bloc state in other interfaces
            bloc.add(PausePlayCurrent(isRunning: !isPlaying));

          },
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: !isCurrent?null:()async{
            await controller.player.seekToNext();
          },
        ),
      ],
    );
  }

}