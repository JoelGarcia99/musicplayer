import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.musicTile.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/services/controller.audio.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class DraggableBottomSheet extends StatefulWidget {


  late final List<SongModel> playlist;

  DraggableBottomSheet({List<SongModel>? playlist}) {
    this.playlist = playlist ?? AudioCustomQuery.queryedAudios;
  }

  @override
  _DraggableBottomSheetState createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {

  late Size screenSize;
  late bool isExpanded;

  @override
  void initState() { 
    super.initState();  
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;

    final height = screenSize.height * (!isExpanded? 
        AppThemeData().initialBottomSheetSize
        :
        AppThemeData().finalBottomSheetSize
      );


    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: height,
        decoration: BoxDecoration(
          color: AppThemeData().primaryDark.withGreen(20),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppThemeData().bottomSheetTopBorders),
            topRight: Radius.circular(AppThemeData().bottomSheetTopBorders),
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              onTap: ()=>setState((){
                  isExpanded = !isExpanded;
                }),
              title: Container(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsetsDirectional.all(5.0),
                        width: screenSize.width * 0.15,
                        height: 5.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).next_in_playlist,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppThemeData().textColor
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<bool>(
              stream: PlayerController().player.shuffleModeEnabledStream,
              initialData: false,
              builder: (context, snapshot) {

                List<SongModel> list = widget.playlist;

                if(snapshot.data!) {
                  list = PlayerController().player.effectiveIndices!.map<SongModel>((int index) {
                    return list[index];
                  }).toList();
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                        return Container(
                          child: MusicTile(
                            item: list[index]
                          ),
                        );
                    },
                  ),
                );
              }
            )
          ],
        )
      );
  }
}