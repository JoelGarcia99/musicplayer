import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTile extends StatelessWidget {
  late final PlayerController playerController;
  static late MusicBloc? bloc;

  final SongModel item;

  MusicTile({
    required this.item,
  }) {
    playerController = new PlayerController();
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<MusicBloc>();

    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        
        bool isCurrent = false;

        if(state is MusicWithSelection) {
          isCurrent = state.current.id == item.id;
        }

        bool isPlaying = isCurrent && playerController.player.playing;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
          decoration: BoxDecoration(
              color: isCurrent
                  ? AppThemeData().focusCardColo
                  : AppThemeData().cardColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 2.0,
                  offset: Offset(1.0, 2.0),
                )
              ]),
          child: ListTile(
            title: Text(
              item.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(item.artist),
            leading: QueryArtworkWidget(
              keepOldArtwork: true,
              artworkBorder: BorderRadius.zero,
              id: item.id,
              type: ArtworkType.AUDIO,
              artwork: item.artwork,
              deviceSDK: DeviceHelper().sdk,
              nullArtworkWidget: Icon(Icons.music_note),
            ),
            trailing: IconButton(
              onPressed: () async {
                if (isCurrent) {
                  if (isPlaying)
                    await playerController.pause();
                  else
                    playerController.play(isNewSong: false);
                } else {
                  await playerController.play(
                      index:
                          AudioCustomQuery.musicDataindex[item.data] ?? 0,
                      isNewSong: true);
                }

                bloc!.add(PausePlayCurrent(isRunning: !isPlaying));
              },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)
            )
          ),
        );
      },
    );
  }
}
