import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/player/MainScreen.dart';
import 'package:musicplayer/services/audio_custom_service.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:route_transitions/route_transitions.dart';

/// This is the player that is showed at the bottom of
/// the screen. Do not cbe confused with the bottom
/// sheet that shows the playlist items, they are pretty 
/// different
class PlayerBottomSheet extends StatelessWidget {
  final double? height;
  late final PlayerController _controller;

  static PlayerBottomSheet? _instance;

  factory PlayerBottomSheet({double? height}) {
    if(_instance == null) {
      _instance = new PlayerBottomSheet._(height: height);
    }

    return _instance!;
  }

  PlayerBottomSheet._({this.height}) {
    this._controller = new PlayerController();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final height = this.height ?? MediaQuery.of(context).size.height * 0.1;

    return StreamBuilder<int?>(
      stream: PlayerController().player.currentIndexStream,
      initialData: 0,
      builder: (context, snapshot) {

        final current = AudioCustomQuery.queryedAudios[snapshot.data ?? 0];

        return GestureDetector(
          onVerticalDragStart: (_)=>slideUpWidget(
            newPage: MainPlayerScreen(), 
            context: context
          ),
          child: Container(
            height: height,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: _controller.player.positionStream,
                  initialData: Duration(milliseconds: 0),
                  builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                    return Container(
                      height: height * 0.03,
                      color: Colors.blue,
                      margin: EdgeInsetsDirectional.only(bottom: 2),
                      width: screenWidth * 
                          snapshot.data!.inMilliseconds
                          / (_controller.player.duration?.inMilliseconds ?? 1),
                    );
                  },
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      QueryArtworkWidget(
                        id: current.id, 
                        type: ArtworkType.AUDIO, 
                        artwork: current.artwork, 
                        deviceSDK: DeviceHelper().sdk,
                        artworkBorder: BorderRadius.zero,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: _getSongInfo(current)
                        ),
                      ),
                      _actionButtons()
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getSongInfo(SongModel current) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          current.title,
          style: TextStyle(
            color: AppThemeData().textColor,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          current.artist,
          style: TextStyle(
            color: AppThemeData().textColor,
            fontSize: 13.0,
          ),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _actionButtons() {

    return StreamBuilder<bool>(
      stream: PlayerController().player.playingStream,
      initialData: false,
      builder: (context, snapshot) {

        final bool isPlaying = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.skip_previous,
                color: AppThemeData().iconColor,
                size: 25.0,
              ),
              onPressed: ()async{
                await _controller.player.seekToPrevious();
              },
            ),
            IconButton(
              icon: Icon(
                isPlaying? Icons.pause:Icons.play_arrow, 
                color: AppThemeData().iconColor,
                size: 25.0,
              ),
              onPressed: ()async {
    
                // If it's playing, then I wanna pause it
                if(isPlaying) {
                  await _controller.pause();
                }
                else {
                  _controller.play(isNewSong: false);
                }
    
              },
            ),
            IconButton(
              icon: Icon(
                Icons.skip_next,
                color: AppThemeData().iconColor,
                size: 25.0,
              ),
              onPressed: ()async{
                await _controller.player.seekToNext();
              },
            ),
          ],
        );
      }
    );
  }
}
