import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'component.progressBar.dart';
import 'controller.player.dart';

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
            _getSongArtwork(state),
            _actionButtons(state),
            if(state is MusicWithSelection) ProgressBar()
          ],
        );
      }
    );
  }

  Widget _actionButtons(MusicState state) {

    late final bool isPlaying;
    bool isCurrent = false;

    if(state is MusicInitial) isPlaying = false;
    else if(state is MusicWithSelection) {
      isCurrent = true;
      isPlaying = state.isRunning;
    }
    else isPlaying = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: !isCurrent?null:(){},
        ),
        IconButton(
          icon: Icon(
            isPlaying? Icons.pause:Icons.play_arrow, 
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: ()async {

            // If it's playing, then I wanna pause it
            if(isPlaying) {
              await controller.pause();
              bloc.add(PausePlayCurrent(isRunning: false));
            }
            else {
              await controller.play();
              bloc.add(PausePlayCurrent(isRunning: true));
            }

          },
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 40.0,
          ),
          onPressed: !isCurrent?null:(){},
        ),
      ],
    );
  }

  Widget _getSongArtwork(MusicState state) {

    final portFraction = containerSize.width * 0.7;

    return Column(
      children: [
        if(state is MusicWithSelection)
          ...[
            QueryArtworkWidget(
              artworkHeight: portFraction,
              artworkWidth: portFraction,
              id: state.current.id,
              type: ArtworkType.AUDIO,
              artwork: state.current.artwork,
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                  width: portFraction,
                  height: portFraction,
                ),
              ),
              deviceSDK: DeviceHelper().sdk,
            ),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                state.current.title,
                style: TextStyle(fontSize: 20.0, color: AppThemeData().iconColor),
              ),
            ),
          ]
        else
          ...[
            Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.fitHeight,
              width: portFraction,
              height: portFraction,
            ),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "No audio selected",
                style: TextStyle(fontSize: 20.0, color: AppThemeData().iconColor),
              ),
            ),
          ]
      ]
    );
  }

}