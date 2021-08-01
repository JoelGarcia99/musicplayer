import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/player/MainScreen.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:route_transitions/route_transitions.dart';

class PlayerBottomSheet extends StatelessWidget {
  final double? height;
  static MusicBloc? bloc;
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
    if(bloc == null) bloc = context.read<MusicBloc>();

    final screenWidth = MediaQuery.of(context).size.width;
    final height = this.height ?? MediaQuery.of(context).size.height * 0.1;

    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {

        if(!(state is MusicWithSelection)) return Container();
        final current = state.current;

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
                      _actionButtons(state)
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

  Widget _actionButtons(MusicState state) {

    bool isCurrent = false;
    final bool isPlaying = (state is MusicWithSelection)? state.isRunning:false;

    if(state is MusicWithSelection) {
      isCurrent = true;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 25.0,
          ),
          onPressed: !isCurrent?null:()async{
            await _controller.player.seekToPrevious();
          },
        ),
        IconButton(
          icon: Icon(
            isPlaying? Icons.pause:Icons.play_arrow, 
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 25.0,
          ),
          onPressed: !isCurrent?null:()async {

            // If it's playing, then I wanna pause it
            if(isPlaying) {
              await _controller.pause();
            }
            else {
              _controller.play(isNewSong: false);
            }

            // updating bloc state in other interfaces
            bloc!.add(PausePlayCurrent(isRunning: !isPlaying));

          },
        ),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: isCurrent?AppThemeData().iconColor:Colors.grey,
            size: 25.0,
          ),
          onPressed: !isCurrent?null:()async{
            await _controller.player.seekToNext();
          },
        ),
      ],
    );
  }
}
