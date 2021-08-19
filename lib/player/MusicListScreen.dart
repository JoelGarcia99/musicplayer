import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.musicTile.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'controller.player.dart';


class MusicListWidget extends StatelessWidget {

  static Size? screenSize;
  static MusicBloc? bloc;
  late final List<SongModel> items;

  static MusicListWidget? _instance;

  factory MusicListWidget() {
    if(_instance == null) {
      _instance = new MusicListWidget._();
    }

    return _instance!;
  }

  MusicListWidget._(){
    this.items = AudioCustomQuery.queryedAudios;
  }

  @override
  Widget build(BuildContext context) {

    if(screenSize == null) screenSize = MediaQuery.of(context).size;
    if(bloc == null) bloc = context.read<MusicBloc>();

    bloc!.add(AddSongs(songs: AudioCustomQuery.queryedAudios));

    // updating application state when a song is changed
    PlayerController().onMusicSkip((int index){
      bloc!.add(AddCurrent(song: items[index]));

      if(!PlayerController().player.playing) {
        bloc!.add(PausePlayCurrent(isRunning: false));
      }
    });

    return Scaffold(
      bottomSheet: Container(
        height: screenSize!.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, musicState) {

          final List<SongModel> items = bloc!.state.songs;

          if(items.isEmpty) {
            return Container(child: Text("There are not items"),);
          }
    
          return Stack(
            children: [
              AppThemeData().getBackgroundImage(screenSize!),
              AppThemeData().getBackgroundColor(screenSize!),
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
	PlayerAppBar(title: "Music list", withHeaders: true, actions: [
	  IconButton(
	      icon: Icon(Icons.settings),
	      onPressed: ()=>Navigator.of(mainContext).pushNamed(Routes.SETTINGS),
	  )
	]),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {

              final playerController = new PlayerController();
              
              final isCurrent = (musicState as MusicWithSelection).current.id == items[index].id;
              final isPlaying = isCurrent && playerController.player.playing;
              
              return MusicTile(
                isCurrent: isCurrent,
                item: items[index],
                isPlaying: isPlaying
              );
            }
          ),
        ),
        SizedBox(height: screenSize!.height * 0.1,)
      ],
    );
  }
}
