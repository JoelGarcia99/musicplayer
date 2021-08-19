import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';

class PlayerDrawer extends StatelessWidget {

  final BuildContext parentContext;

  PlayerDrawer({ required this.parentContext });

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: screenSize.width*0.7,
          color: Colors.black.withOpacity(0.6),
          child: ListView(
            children: [
              Container(
                color: Colors.black,
                child: ListTile(
                  leading: Icon(Icons.menu, color: AppThemeData().iconColor,),
                  title: Text("Menu", style: TextStyle(color: AppThemeData().iconColor),),
                  onTap: ()=>SmartDialog.dismiss(),
                ),
              ),
              ListTile(
                leading: Icon(Icons.graphic_eq, color: AppThemeData().iconColor),
                title: Text("Music list", style: TextStyle(color: AppThemeData().iconColor),),
                onTap: () {
                  SmartDialog.dismiss();
                  Navigator.of(parentContext).pushReplacementNamed(Routes.MUSIC_LIST);
                },
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.youtube,
                  color: AppThemeData().iconColor,
                ),
                title: Text(
                  "YouTube music downloader", 
                  style: TextStyle(color: AppThemeData().iconColor),
                ),
                onTap: () {
                  SmartDialog.dismiss();
                  Navigator.of(parentContext).pushReplacementNamed(Routes.YOUTUBE_DOWNLOADER);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}