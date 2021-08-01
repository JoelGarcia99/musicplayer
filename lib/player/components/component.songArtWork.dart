import 'package:animated_overflow/animated_overflow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerArtWork extends StatelessWidget {
  
  final double? imageSize;
  late final MusicBloc bloc;

  PlayerArtWork({this.imageSize});

  @override
  Widget build(BuildContext context) {

    this.bloc = context.read<MusicBloc>();

    final containerSize = MediaQuery.of(context).size;
    final portFraction = this.imageSize ?? containerSize.width * 0.7;

    final state = bloc.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if(state is MusicWithSelection)
          ...[
            QueryArtworkWidget(
              artworkHeight: portFraction,
              artworkWidth: portFraction,
              id: state.current.id,
              type: ArtworkType.AUDIO,
              artwork: state.current.artwork,
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                  width: portFraction,
                  height: portFraction,
                ),
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
                    state.current.title,
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
        else
          ...[
            Hero(
              tag: 'assets/images/background.jpg',
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fitHeight,
                width: portFraction,
                height: portFraction,
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "No audio selected",
                style: TextStyle(fontSize: 20.0, color: AppThemeData().iconColor),
              ),
            ),
          ]
      ]
    );
  }
}