import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/router/routes.dart';
 
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  
  await DeviceHelper().init();

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
        initialRoute: '/home',
        builder: (context, child){
          return FlutterSmartDialog(
            child: child
          );
        },
        routes: buildRoutes(),
      )
    );
  }
}