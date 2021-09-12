class _SongHelper {

  const _SongHelper();
  
  String getSizeString(double bytes) {

    late final sizeUnit;
    double response = bytes;
  
    if(bytes < 1000000) {
      if(bytes > 1000) {
        sizeUnit = 'KB';
        response /= 1000;
      }
      else {
        sizeUnit = 'B';
      }
    }
    else {
      sizeUnit = 'MB';
      response /= 1000000;
    }

    return "${response.toStringAsFixed(2)} $sizeUnit";
  }

  String formatDuration(Duration duration) {
    int min = duration.inMinutes;
    int sec = duration.inSeconds - duration.inMinutes * 60;

    return "${min<=9? "0":""}$min:${sec <= 9? "0":""}$sec";
  }

}


const songHelper = const _SongHelper();