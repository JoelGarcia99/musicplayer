import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.singerTile.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SingersScreen extends StatelessWidget {
  static Size? screenSize;
  static MusicBloc? bloc;
  static BuildContext? context;

  static SingersScreen? _instance;

  factory SingersScreen() {
    if(_instance == null) {
      _instance = new SingersScreen._();
    }

    return _instance!;
  }

  SingersScreen._();

  @override
  Widget build(BuildContext context) {

    SingersScreen.context = context;

    if(screenSize == null) screenSize = MediaQuery.of(context).size;
    if(bloc == null) bloc = context.read<MusicBloc>();

    // bloc.add(AddSongs(songs: AudioCustomQuery.queryedAudios));

    return Scaffold(
      bottomSheet: Container(
        height: screenSize!.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: FutureBuilder<List<ArtistModel>>(
        future: AudioCustomQuery().queryArtists(),
        builder: (context, snapshot) {

          if(!snapshot.hasData) {
            SmartDialog.showLoading();
            return Container();
          }

          SmartDialog.dismiss();

          return Stack(
            children: [
              AppThemeData().getBackgroundImage(screenSize!),
              AppThemeData().getBackgroundColor(screenSize!),
              _content(snapshot.data!, context),
            ],
          );
        }
      ),
    );
  }

  Widget _content(List<ArtistModel> items, BuildContext mainContext) {
    return Column(
      children: [
        PlayerAppBar(
          title: S.of(SingersScreen.context!).singers,
          withHeaders: true,
          active: AppBarMenuOptions.Singers,
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              
              return SingerTile(singer: items[index]);
            }
          ),
        ),
        SizedBox(height: screenSize!.height * 0.1,)
      ],
    );
  }
}

