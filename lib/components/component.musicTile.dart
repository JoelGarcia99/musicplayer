import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/helper.device.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/services/controller.audio.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTile extends StatelessWidget {
  late final PlayerController playerController;

  final SongModel item;
  final bool showPlayButton;

  MusicTile({
    required this.item, this.showPlayButton = true,
  }) {
    playerController = new PlayerController();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<int?>(
      stream: PlayerController().player.currentIndexStream,
      initialData: 0,
      builder: (context, state) {

        final currentPlaying = PlayerController().player.audioSource?.sequence[state.data!];
        
        late bool isCurrent;
        
        if(currentPlaying != null) {
          isCurrent = (currentPlaying.tag as MediaItem).id == item.id.toString();
        }
        else {
          isCurrent = false;
        }

        Color textColor = isCurrent?
          AppThemeData().textFocusColor
          :AppThemeData().textColor;
        Color iconColor = textColor;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          decoration: BoxDecoration(
              color: isCurrent?
                AppThemeData().focusCardColo
                :AppThemeData().cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 2.0,
                  offset: Offset(1.0, 2.0),
                )
              ]),
          child: StreamBuilder<bool>(
            stream: PlayerController().player.playingStream,
            initialData: false,
            builder: (context, snapshot) {
              return ListTile(
                title: Text(
                  "${item.bookmark} ${item.displayName}",
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${item.artist} - ${item.album}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor
                  ),
                ),
                leading: QueryArtworkWidget(
                  keepOldArtwork: true,
                  artworkBorder: BorderRadius.zero,
                  id: item.id,
                  type: ArtworkType.AUDIO,
                  artwork: item.artwork,
                  deviceSDK: DeviceHelper().sdk,
                  nullArtworkWidget: Icon(
                    Icons.music_note, 
                    color: iconColor
                  )
                ),
                trailing: this.showPlayButton? IconButton(
                  onPressed: () async {
                    if (isCurrent) {
                      if (snapshot.data!)
                        await playerController.pause();
                      else
                        playerController.play(isNewSong: false);
                    } else {
                      await playerController.play(
                        index: AudioCustomQuery.musicDataindex[item.data] ?? 0,
                        isNewSong: true
                      );
                    }
                  },
                  icon: Icon(
                      isCurrent && snapshot.data!?
                      Icons.pause: 
                      Icons.play_arrow,
                      color: iconColor
                    )
                  ): Container()
              );
            }
          ),
        );
      },
    );
  }
}
