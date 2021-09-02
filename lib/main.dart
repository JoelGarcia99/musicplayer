import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/router/routes.dart';

import 'generated/l10n.dart';
 
void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'en';
  
  await DeviceHelper().init();
  await AudioCustomQuery().quearyAudios(false);

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<MusicBloc>(
          create: (BuildContext context) => MusicBloc(),
        ),
      ], 
      child: MaterialApp(
        title: 'Material App',
        initialRoute: Routes.MUSIC_LIST,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, child){
          return FlutterSmartDialog(
            child: AudioServiceWidget(child: child!)
          );
        },
        routes: buildRoutes(),
      )
    );
  }
}