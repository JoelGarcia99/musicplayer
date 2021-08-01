import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller.player.dart';

class MusicTile extends StatelessWidget {

  late final PlayerController playerController;
  late final MusicBloc bloc;

  final bool isCurrent;
  final SongModel item;
  final bool isPlaying;

  MusicTile({
    required this.isCurrent, 
    required this.item,
    required this.isPlaying, 
  }) {
    playerController = new PlayerController();
  }

  @override
  Widget build(BuildContext context) {

    this.bloc = context.read<MusicBloc>();

    double size = item.size / 1.0;
    late final sizeUnit;
  
    if(size < 1000000) {
      if(size > 1000) {
        sizeUnit = 'KB';
        size /= 1000;
      }
      else {
        sizeUnit = 'B';
      }
    }
    else {
      sizeUnit = 'MB';
      size /= 1000000;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      decoration: BoxDecoration(
        color: isCurrent? AppThemeData().focusCardColo:AppThemeData().cardColor,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            offset: Offset(1.0, 2.0),
          )
        ]
      ),
      child: ListTile(
        title: Text(
          item.displayName, 
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(item.artist),
        leading:  QueryArtworkWidget(
          keepOldArtwork: true,
          artworkBorder: BorderRadius.zero,
          id: item.id,
          type: ArtworkType.AUDIO,
          artwork: item.artwork,
          deviceSDK: DeviceHelper().sdk,
        ),
        trailing: IconButton(
          onPressed: ()async{
            
            if(isCurrent) {
              if(isPlaying) await playerController.pause();
              else playerController.play(isNewSong: false);
            }
            else {
              await playerController.play(
                index: AudioCustomQuery.musicDataindex[
                  item.data
                ] ?? 0,
                isNewSong: true
              );
            }

            bloc.add(PausePlayCurrent(isRunning: !isPlaying));
          },
          icon: Icon(isPlaying? Icons.pause:Icons.play_arrow)
        )
      ),
    );
  }
}