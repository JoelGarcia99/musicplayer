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

    return "$response $sizeUnit";
  }
}

const songHelper = const _SongHelper();