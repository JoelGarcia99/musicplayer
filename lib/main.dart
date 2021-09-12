import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl_browser.dart';
import 'package:musicplayer/data/user_preferences.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/services/audio_custom_service.dart';
import 'package:musicplayer/router/routes.dart';

import 'generated/l10n.dart';
 
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  
  await UserPreferences().initPreferences();

  /// Extract some useful device info
  await DeviceHelper().init();

  /// This will query all the audios on your device.
  /// The [withLoader] parameter is used to show a 
  /// loader but since we're in main method it's
  /// not necessary yet
  await AudioCustomQuery().quearyAudios(false);

  /// This will initialize all the services in the background such
  /// as notification banner and lock screen controlls
  await PlayerController().initService();

  UserPreferences().language = await findSystemLocale();

  /// blocking landscape rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<String>(
      stream: UserPreferences().lanStream,
      initialData: UserPreferences().language,
      builder: (context, snapshot) {
    
        return MaterialApp(
          title: 'Devall Music Player',
          initialRoute: Routes.MUSIC_LIST,
          locale: new Locale(UserPreferences().language),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          builder: (context, child){
            return FlutterSmartDialog(
              child: child!
            );
          },
          routes: buildRoutes(),
        );
      }
    );
  }
}