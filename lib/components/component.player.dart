import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/services/audio_custom_service.dart';
import 'package:musicplayer/ui/theme.dart';

import 'component.progressBar.dart';
import 'component.songArtWork.dart';

class CustomPlayer extends StatelessWidget {
  final double mainIconsSize = 30.0;
  final double iconsSize = 25.0;

  late final Size containerSize;
  final PlayerController controller = new PlayerController();

  @override
  Widget build(BuildContext context) {

    containerSize = MediaQuery.of(context).size;

    return Column(
      children: [
        PlayerArtWork(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: AppThemeData().backgroundColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(0.0, 2.0)
              )
            ]
          ),
          child: _actionButtons()
        ),
        ProgressBar()
      ],
    );
  }

  Widget _actionButtons() {

    return StreamBuilder<bool>(
      stream: PlayerController().player.playingStream,
      initialData: false,
      builder: (context, snapshot) {

        final isPlaying = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getRepeatButton(),
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color:AppThemeData().iconColor,
                size: mainIconsSize,
              ),
              onPressed: ()async{
                await controller.player.seekToPrevious();
              },
            ),
            IconButton(
              icon: Icon(
                isPlaying? Icons.pause:Icons.play_arrow, 
                color: AppThemeData().iconColor,
                size: mainIconsSize,
              ),
              onPressed: ()async {
    
                if(isPlaying) {
                  await controller.pause();
                }
                else {
                  controller.play(isNewSong: false);
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: AppThemeData().iconColor,
                size: mainIconsSize,
              ),
              onPressed: ()async{
                await controller.player.seekToNext();
              },
            ),
            _getShuffleButton()
          ],
        );
      }
    );
  }

  IconData _getShuffleIcon() {
    return controller.player.shuffleModeEnabled?
      Icons.shuffle_on_outlined:
      Icons.shuffle;
  }

  IconData _getRepeatIcon() {
    switch(controller.player.loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one_outlined;
      case LoopMode.all:
        return Icons.repeat_on_outlined;
    }
  }

  Widget _getRepeatButton() {
    return StreamBuilder<LoopMode>(
      stream: controller.player.loopModeStream,
      initialData: LoopMode.off,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return IconButton(
          icon: Icon(
            _getRepeatIcon(),
            color: AppThemeData().iconColor,
            size: iconsSize,
          ),
          onPressed: (){
              late LoopMode mode;

              switch(snapshot.data) {
                  
                case LoopMode.off:
                  mode = LoopMode.all;
                  break;
                case LoopMode.one:
                  mode = LoopMode.off;
                  break;
                case LoopMode.all:
                  mode = LoopMode.one;
                  break;
              }

              controller.player.setLoopMode(mode);
          }
        );
      },
    );
  }

  Widget _getShuffleButton() {
    return StreamBuilder<bool>(
      stream: controller.player.shuffleModeEnabledStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return 
        IconButton(
          icon: Icon(
            _getShuffleIcon(),
            color:AppThemeData().iconColor,
            size: iconsSize,
          ),
          onPressed: (){
            bool shouldShuffle = !snapshot.data;
            controller.player.setShuffleModeEnabled(shouldShuffle);
            controller.player.shuffle();
          }
        );
      },
    );
  }
}