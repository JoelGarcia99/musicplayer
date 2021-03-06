import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/database/controller.database.dart';
import 'package:musicplayer/helpers/helper.cache.dart';
import 'package:musicplayer/helpers/helper.device.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/services/controller.audio.dart';
import 'package:musicplayer/router/routes.dart';

import 'generated/l10n.dart';
 
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  
  await UserPreferences().initPreferences();

  /// initializing SQFlite
  await LocalDatabase().init();

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
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
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