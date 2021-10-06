import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.musicTile.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';


class MusicListWidget extends StatelessWidget {

  static Size? screenSize;
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

    return Scaffold(
      bottomSheet: Container(
        height: screenSize!.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: Stack(
        children: [
          AppThemeData().getBackgroundImage(screenSize!),
          AppThemeData().getBackgroundColor(screenSize!),
          _content(context),
        ],
      ),
    );
  }

  Widget _content(BuildContext mainContext) {
    return Column(
      children: [
        PlayerAppBar(title: S.of(mainContext).music_list, withHeaders: true),
        StreamBuilder<List<SongModel>>(
          stream: AudioCustomQuery().songStream,
          initialData: AudioCustomQuery.queryedAudios,
          builder: (context, snapshot) {
            return Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  
                  return MusicTile(
                    item: snapshot.data![index]
                  );
                }
              ),
            );
          }
        ),
        SizedBox(height: screenSize!.height * 0.1,)
      ],
    );
  }
}
