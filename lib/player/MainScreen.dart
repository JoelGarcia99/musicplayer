import 'dart:ui';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/player/audioQuery.dart';
import 'package:musicplayer/player/component.player.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainPlayerScreen extends StatelessWidget {

  late final AppThemeData theme;
  late final Size screenSize;
  late final BuildContext context;
  late final MusicBloc bloc;

  MainPlayerScreen() {
    this.theme = AppThemeData();
  }

  @override
  Widget build(BuildContext context) {

    this.context = context;
    this.screenSize = MediaQuery.of(context).size;

    bloc = context.read<MusicBloc>();

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
            Expanded(child: Container()),
            Container(
              height: screenSize.height*0.6,
              width: screenSize.width,
              child: CustomPlayer()
            ),
            Expanded(child: Container()),
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
          icon: Icon(
            Icons.menu, 
            color: AppThemeData().iconColor,
          ),
          onPressed: (){

            SmartDialog.show(
              clickBgDismissTemp: true,
              alignmentTemp: Alignment.centerLeft,
              widget: SafeArea(
                child: Container(
                  width: screenSize.width*0.7,
                  color: Colors.black.withOpacity(0.6),
                  child: ListView(
                    children: [
                      Container(
                        color: Colors.black,
                        child: ListTile(
                          leading: Icon(Icons.menu, color: AppThemeData().iconColor,),
                          title: Text("Menu", style: TextStyle(color: AppThemeData().iconColor),),
                          onTap: ()=>SmartDialog.dismiss(),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.graphic_eq, color: AppThemeData().iconColor),
                        title: Text("Music list", style: TextStyle(color: AppThemeData().iconColor),),
                        onTap: () {
                          SmartDialog.dismiss();
                          Navigator.of(context).pushNamed(Routes.MUSIC_LIST);
                        },
                      )
                    ],
                  ),
                ),
              )
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.tune, color: AppThemeData().iconColor,),
          onPressed: ()=>Navigator.of(context).pushNamed(Routes.SETTINGS),
        )
      ],
    );
  }

}