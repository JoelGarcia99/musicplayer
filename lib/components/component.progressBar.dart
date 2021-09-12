import 'package:flutter/material.dart';
import 'package:musicplayer/services/audio_custom_service.dart';
import 'package:musicplayer/ui/theme.dart';

class ProgressBar extends StatelessWidget {

  late final Stream<Duration> progressStream;
  late final PlayerController controller;

  ProgressBar() {
    controller = new PlayerController();
    progressStream = controller.player.positionStream;
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: progressStream,
      initialData: Duration(seconds: 0),
      builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {

        final minutesProgress = snapshot.data!.inMinutes;
        final secondsProgress = snapshot.data!.inSeconds % 60;

        final minutesSong = controller.player.duration?.inMinutes ?? 0;
        final secondsSong = (controller.player.duration?.inSeconds ?? 0) % 60;

        final position = (snapshot.data!.inMilliseconds*1.00);
        final maxValue = (controller.player.duration?.inMilliseconds ?? 0) * 1.0;

        return Container(
          child: Column(
            children: [
              Slider(
                min: 0.0,
                max: maxValue,
                value: (position >= 0.0 && position <= maxValue)? position:0.0,
                onChanged: (position){
                  controller.player.seek(Duration(milliseconds: position~/1));
                },
              ),
              Text(
                "${(minutesProgress < 10)? "0":""}$minutesProgress:${(secondsProgress < 10)? "0":""}$secondsProgress"
                "/${(minutesSong < 10)? "0":""}$minutesSong:${(secondsSong < 10)? "0":""}$secondsSong",
                style: TextStyle(
                  color: AppThemeData().iconColor
                ),
              )
            ],
          ),
        );
      },
    );
  }
}