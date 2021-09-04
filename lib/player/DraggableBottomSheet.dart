import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.musicTile.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:musicplayer/ui/theme.dart';

class DraggableBottomSheet extends StatefulWidget {

  const DraggableBottomSheet({ Key? key }) : super(key: key);

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


    return GestureDetector(
      onTap: () {
        setState((){
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppThemeData().bottomSheetTopBorders),
            topRight: Radius.circular(AppThemeData().bottomSheetTopBorders),
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
            Text(S.of(context).next_in_playlist),
            Expanded(
              child: ReorderableListView(
                onReorder: (prevIdx, nextIdx) {
                  setState(() {
                    if (prevIdx < nextIdx) {
                      nextIdx -= 1;
                    }
                    final item = AudioCustomQuery.queryedAudios.removeAt(prevIdx);

                    // updating list of extracted audios
                    AudioCustomQuery.queryedAudios.insert(nextIdx, item);

                    // updating data indices
                    AudioCustomQuery().generateDataIndex();

                    // updating playlist. Remember that this is a service so
                    // you need to update it as well as you did with [queryedAudios]
                    PlayerController().updatePlaylist(
                       AudioCustomQuery.queryedAudios,
                       nextIdx,
                    );
                  }); 
                },
                children: List<Widget>.from((AudioCustomQuery.queryedAudios).map((audio){
                  return Container(
                    key: new Key(audio.id.toString()),
                    child: MusicTile(
                      item: audio
                    ),
                  );
                })),
              ),
            )
          ],
        ),
      ),
    );
  }
}