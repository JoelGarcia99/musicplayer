import 'package:on_audio_query/on_audio_query.dart';

class DeviceHelper {

  static DeviceHelper? _instance;

  factory DeviceHelper() {
    if(_instance == null) {
      _instance = new DeviceHelper._();
    }

    return _instance!;
  }

  DeviceHelper._();

  late final DeviceModel _deviceInfo;

  Future<void> init() async {
    _deviceInfo = await OnAudioQuery().queryDeviceInfo();
  }

  get sdk => _deviceInfo.sdk;
}