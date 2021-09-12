import 'package:animated_overflow/animated_overflow.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/services/audio_custom_service.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerArtWork extends StatelessWidget {
  
  final double? imageSize;

  PlayerArtWork({this.imageSize});

  @override
  Widget build(BuildContext context) {

    /// [containerSize] is the size of the player screen, I mean,
    /// the entire device's screen size. [portFraction] in the other
    /// hand is the size of the image
    final containerSize = MediaQuery.of(context).size;
    final portFraction = this.imageSize ?? containerSize.width;

    return StreamBuilder<int?>(
      stream: PlayerController().player.currentIndexStream,
      initialData: 0,
      builder: (context, snapshot) {

        final MediaItem? current = PlayerController().player.audioSource?.sequence[
          snapshot.data!
        ].tag as MediaItem;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QueryArtworkWidget(
              artworkHeight: portFraction,
              artworkWidth: portFraction,
              id:  int.parse(current?.id ?? "0"),
              type: ArtworkType.AUDIO,
              artwork: current?.artUri?.path,
              artworkBorder: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
                child: Container(
                  color: AppThemeData().cardColor,
                  height: portFraction,
                  width: portFraction,
                  child: Icon(
                    Icons.music_note,
                    size: portFraction * 0.5,
                  ),
                )
              ),
              deviceSDK: DeviceHelper().sdk,
            ),
            SizedBox(height: 10.0,),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: AnimatedOverflow(
                  speed: 50,
                  maxWidth: containerSize.width,
                  animatedOverflowDirection: AnimatedOverflowDirection.HORIZONTAL,
                  child: Text(
                    current?.title ?? "N/A",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(                  
                      fontSize: 20.0, color: AppThemeData().iconColor
                    ),
                  ),
                ),
                
              ),
            ),
          ]
        );
      }
    );
  }
}