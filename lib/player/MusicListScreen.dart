import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/player/components/component.appBar.dart';
import 'package:musicplayer/player/components/component.bottomSheet.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'controller.player.dart';


class MusicListWidget extends StatelessWidget {

  late final Size screenSize;
  late final MusicBloc bloc;
  late final List<SongModel> items;

  MusicListWidget() {
    this.items = AudioCustomQuery.queryedAudios;
  }

  @override
  Widget build(BuildContext context) {

    this.screenSize = MediaQuery.of(context).size;
    this.bloc = context.read<MusicBloc>();

    bloc.add(AddSongs(songs: AudioCustomQuery.queryedAudios));

    // updating application state when a song is changed
    PlayerController().onMusicSkip((int index){
      bloc.add(AddCurrent(song: items[index]));

      if(!PlayerController().player.playing) {
        bloc.add(PausePlayCurrent(isRunning: false));
      }
    });

    return Scaffold(
      bottomSheet: Container(
        height: screenSize.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, musicState) {

          final List<SongModel> items = bloc.state.songs;

          if(items.isEmpty) {
            return Container(child: Text("There are not items"),);
          }
    
          return Stack(
            children: [
              AppThemeData().getBackgroundImage(screenSize),
              AppThemeData().getBackgroundColor(screenSize),
              _content(items, musicState, context),
            ],
          );
        }
      ),
    );
  }

  Widget _content(List<SongModel> items, MusicState musicState, BuildContext mainContext) {
    return Column(
      children: [
        PlayerAppBar(title: "Music list", withHeaders: true,),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {

              final playerController = new PlayerController();
              
              final isCurrent = (musicState as MusicWithSelection).current.id == items[index].id;
              final isPlaying = isCurrent && playerController.player.playing;
              
              return _musicTile(
                isCurrent: isCurrent,
                item: items[index],
                isPlaying: isPlaying,
                playerController: playerController,
                context: mainContext
              );
            }
          ),
        ),
        SizedBox(height: screenSize.height * 0.1,)
      ],
    );
  }

  Widget _musicTile({
    required bool isCurrent, 
    required SongModel item,
    required bool isPlaying, 
    required PlayerController playerController, 
    required BuildContext context
  }) {

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
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: isCurrent? AppThemeData().focusCardColo:AppThemeData().cardColor,
        borderRadius: BorderRadius.circular(10.0),
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
        subtitle: Text(
          "${size.toStringAsFixed(2)} "
          "$sizeUnit - ${item.composer ?? "unknow author"}"
        ),
        leading:  QueryArtworkWidget(
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

              // Navigator.of(context).pop();
            }

            bloc.add(PausePlayCurrent(isRunning: !isPlaying));
          },
          icon: Icon(isPlaying? Icons.pause:Icons.play_arrow)
        )
      ),
    );
  }
}