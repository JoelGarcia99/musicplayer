import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/helper.device.dart';
import 'package:musicplayer/services/controller.audio.dart';
import 'package:musicplayer/ui/theme.dart';

import 'package:on_audio_query/on_audio_query.dart';

class RotationArtwork extends StatefulWidget {

  /// The diameter of the disc
  final double portFraction;

  const RotationArtwork({Key? key, required this.portFraction}) : super(key: key);

  @override
  State<RotationArtwork> createState() => _RotationArtworkState();
}

class _RotationArtworkState extends State<RotationArtwork> {

  late double angle; // How many radians should the disc rotate
  late Widget child; // The artwork from the song metadata
  late int period; // Refresh rate

  // If the audio isn't playing then the disc shouldn't rotate
  late bool isPlaying;

  @override
  void initState() {

    /// [angle] is in radian units, so, with 2.0 I'm saying 
    /// that the disc should perform a full rotation every 
    /// [period] milliseconds every time [isPlaying] is true
    angle = 2.0;
    period = 1000;
    isPlaying = false;

    /// Since we're using this child in the initState it
    /// will not be rendered when setState is called, so, 
    /// StreamBuilder is the way to update the artwork when 
    /// the music change.
    /// 
    /// WARNING: Do not put it into any build method since
    /// setState will render it every [period] milliseconds
    /// so the app could crash after some time
    child = _getArtworkRotationWidget();
    
    /// This will controll all the disc rotation animation
    Timer.periodic(Duration(milliseconds: period), (timer) {

      isPlaying = PlayerController().player.playing;

      if(isPlaying) {
        setState(() {
          angle += 0.1;
        });
      }
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    /// Since this is called a lot of times during the app
    /// excecution, keep it as simple as you can
    return AnimatedRotation(
      duration: Duration(milliseconds: period),
      turns: angle,
      child: child
    );
  }

  /// This is the rotation widget itself
  Widget _getArtworkRotationWidget() {
    return StreamBuilder<int?>(
      stream: PlayerController().player.currentIndexStream,
      initialData: 0,
      builder: (context, snapshot) {

        /// When I extract the music in the CustomAudioQuery
        /// helper I use the 'tag' element as a MediaItem, that's
        /// why I parse it as that
        final MediaItem? current = PlayerController().player.audioSource?.sequence[
          snapshot.data!
        ].tag as MediaItem;

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.portFraction),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.portFraction)
            ),
            child: QueryArtworkWidget(
              artworkHeight: widget.portFraction,
              artworkWidth: widget.portFraction,
              id:  int.parse(current!.id), // This will seach for an image
              type: ArtworkType.AUDIO,
              artwork: current.artUri?.path, // This will be null most of the time
              artworkBorder: BorderRadius.circular(0),
              nullArtworkWidget: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
                  color: AppThemeData().cardColor,
                  height: widget.portFraction,
                  width: widget.portFraction,
                  child: Icon(
                    Icons.music_note,
                    size: widget.portFraction * 0.5,
                  ),
                )
              ),
              deviceSDK: DeviceHelper().sdk,
            ),
          ),
        );
      }
    );
  }
}