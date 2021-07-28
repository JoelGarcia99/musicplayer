import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/ui/theme.dart';

import 'controller.player.dart';

class ProgressBar extends StatelessWidget {

  late final Stream<Duration> progressStream;
  late final PlayerController controller;
  late final MusicBloc bloc;

  ProgressBar() {
    controller = new PlayerController();
    progressStream = controller.player.positionStream;
  }


  @override
  Widget build(BuildContext context) {

    bloc = context.read<MusicBloc>();

    return StreamBuilder(
      stream: progressStream,
      initialData: Duration(seconds: 0),
      builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {

        if(snapshot.data!.inMilliseconds*1.00 >= (controller.player.duration?.inMilliseconds ?? 0) * 1.0) {
          controller.player.stop();
          bloc.add(PausePlayCurrent(isRunning: false));
        }

        final minutesProgress = snapshot.data!.inMinutes;
        final secondsProgress = snapshot.data!.inSeconds % 60;

        final minutesSong = controller.player.duration?.inMinutes ?? 0;
        final secondsSong = (controller.player.duration?.inSeconds ?? 0) % 60;

        return Container(
          child: Column(
            children: [
              Slider(
                min: 0.0,
                max: (controller.player.duration?.inMilliseconds ?? 0) * 1.0,
                value: snapshot.data!.inMilliseconds*1.00,
                onChanged: (position){

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