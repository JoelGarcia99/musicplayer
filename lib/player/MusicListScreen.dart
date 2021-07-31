import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/player/components/component.appBar.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'controller.player.dart';


class MusicListWidget extends StatelessWidget {

  late final Size screenSize;
  late final MusicBloc bloc;

  @override
  Widget build(BuildContext context) {

    this.screenSize = MediaQuery.of(context).size;
    this.bloc = context.read<MusicBloc>();

    return Scaffold(
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, musicState) {
    
          final List<SongModel> items = musicState.songs;
    
          if(items.isEmpty) {
            return Container(child: Text("There are not items"),);
          }
    
          return Stack(
            children: [
              AppThemeData().getBackgroundImage(screenSize),
              AppThemeData().getBackgroundColor(screenSize),
              Column(
                children: [
                  PlayerAppBar(title: "Music list",),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {

                        final playerController = new PlayerController();
                      
                        double size = items[index].size / 1.0;
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

                        final isCurrent = (musicState as MusicWithSelection).current.id == items[index].id;
                        final isPlaying = isCurrent && playerController.player.playing;
                      
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
                              items[index].displayName, 
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "${size.toStringAsFixed(2)} "
                              "$sizeUnit - ${items[index].composer ?? "unknow author"}"
                            ),
                            leading: QueryArtworkWidget(
                              id: items[index].id,
                              type: ArtworkType.AUDIO,
                              artwork: items[index].artwork,
                              deviceSDK: DeviceHelper().sdk,
                            ),
                            trailing: IconButton(
                              onPressed: ()async{
                                
                                if(isCurrent) {
                                  if(isPlaying) await playerController.pause();
                                  else playerController.play(isNewSong: false);

                                  bloc.add(PausePlayCurrent(isRunning: !isPlaying));
                                  Navigator.of(context).pop();
                                }
                                else {
                                  await playerController.play(
                                    index: AudioCustomQuery.musicDataindex[
                                      items[index].data
                                    ] ?? 0,
                                    isNewSong: true
                                  );
                                }
                              },
                              icon: Icon(isPlaying? Icons.pause:Icons.play_arrow)
                            )
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
}