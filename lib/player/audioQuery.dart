import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioCustomQuery {


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

    if(withLoader) {
      await SmartDialog.dismiss();
      await SmartDialog.showToast(audios.isEmpty? "There are no audios":"Music loaded");
    }

    return audios;
  }
}