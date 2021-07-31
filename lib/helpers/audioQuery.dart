import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/player/controller.player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioCustomQuery {

  static List<SongModel> queryedAudios = [];
  static Map<String, int> musicDataindex  = new Map<String, int>();
  static Map<int, SongModel> musicDataIndexReverse = new Map<int, SongModel>();

  Future<List<SongModel>> quearyAudios([withLoader = true]) async {

    if(withLoader) {
      SmartDialog.showLoading(
        msg: "Searching for music",
      );
    }

    List<SongModel> audios = await OnAudioQuery().querySongs(
      SongSortType.DISPLAY_NAME,
      OrderType.ASC_OR_SMALLER,
      UriType.EXTERNAL,
      true
    );

    audios = audios.where((element) => element.size >= 1000000).toList();

    for(int i=0; i<audios.length; ++i) {
      musicDataindex[audios[i].data] = i;
      musicDataIndexReverse[i] = audios[i];
    }

    if(withLoader) {
      await SmartDialog.dismiss();
      await SmartDialog.showToast(audios.isEmpty? "There are no audios":"Music loaded");
    }

    final List<AudioSource> playlist = List<AudioSource>.from(audios.map((SongModel e){
        return AudioSource.uri(Uri.parse(e.data));
    }));

    queryedAudios.addAll(audios);
    await PlayerController().generatePlaylist(playlist);

    return audios;
  }
}