import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/player/audioQuery.dart';
import 'package:musicplayer/player/component.bottomBar.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainPlayerScreen extends StatelessWidget {

  late final AppThemeData theme;
  late final Size screenSize;
  late final BuildContext context;

  MainPlayerScreen() {
    this.theme = AppThemeData();
  }

  @override
  Widget build(BuildContext context) {

    this.context = context;
    this.screenSize = MediaQuery.of(context).size;

    final bloc = context.read<MusicBloc>();

    return Scaffold(
      // drawer: ,
      body: Stack(
        children: [
          _getBackgroundImage(),
          _getBackgroundColor(),
          Container(
            height: screenSize.height,
            child: FutureBuilder(
              future: AudioCustomQuery().quearyAudios(false),
              builder: (context, AsyncSnapshot<List<SongModel>> snapshot) {
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                }
                
                bloc.add(AddSongs(songs: snapshot.data!));
                return _getContent();
              },
            )
          )
        ],
      )
    );
  }

  Widget _getBackgroundImage() {
    return Container(
      width: double.infinity,
      height: screenSize.height,
      child: Image(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _getBackgroundColor() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        width: double.infinity,
        height: screenSize.height,
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget _getContent() {
    return SafeArea(
      // child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: _buildAppBar(),
            ),
            Container(
              width: double.infinity,
              height: screenSize.height*0.3,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/background.jpg'),
                image: AssetImage(
                  'assets/images/background.jpg',                
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "It's Realme.mp3",
                style: TextStyle(fontSize: 20.0, color: AppThemeData().iconColor),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: PlayerBottomBar(),
            ),
            Expanded(child: _getMusicList()),
          ],
        ),
      // ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: Icon(Icons.menu, color: AppThemeData().iconColor,),
          onPressed: (){
            // SmartDialog.show(
            //   widget: widget
            // );
          },
        ),
        IconButton(
          icon: Icon(Icons.tune, color: AppThemeData().iconColor,),
          onPressed: ()=>Navigator.of(context).pushNamed(Routes.SETTINGS),
        )
      ],
    );
  }

  Widget _getMusicList() {

    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, musicState) {

        if(musicState is MusicInitial) {

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
                    onPressed: (){}, 
                    icon: Icon(Icons.play_arrow)
                  )
                ),
              );
            }
          );
        }

        return Container(child: Text("There are no musics"),);
      }
    );
  }
}