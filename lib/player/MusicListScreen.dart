import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'controller.player.dart';

class MusicListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = context.read<MusicBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Music List"),
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, musicState) {
    
          final List<SongModel> items = musicState.songs;
    
          if(items.isEmpty) {
            return Container(child: Text("There are not items"),);
          }
    
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
    
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
    
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  color: AppThemeData().cardColor,
                  borderRadius: BorderRadius.circular(10.0)
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
                      final playerController = new PlayerController();
                      
                      // stopping current song
                      await playerController.player.stop();

                      await playerController.setFile(items[index].data);
                      await playerController.play();
    
                      bloc.add(AddCurrent(song: items[index]));

                      Navigator.of(context).pop();
                    }, 
                    icon: Icon(Icons.play_arrow)
                  )
                ),
              );
            }
          );
        }
      ),
    );
  }
}