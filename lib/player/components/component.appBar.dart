import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';

enum AppBarMenuOptions {
  All, Singers, Albums, Playlists
}

class PlayerAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actions;
  final bool withHeaders;
  final AppBarMenuOptions active;
  const PlayerAppBar({
    required this.title, 
    this.actions,
    this.withHeaders = false, 
    this.active = AppBarMenuOptions.All
  });

  @override
  _PlayerAppBarState createState() => _PlayerAppBarState();
}

class _PlayerAppBarState extends State<PlayerAppBar> {

  late Size screenSize;

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    this.screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu, 
                    color: AppThemeData().iconColor,
                  ),
                  onPressed: (){

                    SmartDialog.show(
                      clickBgDismissTemp: true,
                      alignmentTemp: Alignment.centerLeft,
                      widget: SafeArea(
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
                                    Navigator.of(context).pushReplacementNamed(Routes.MUSIC_LIST);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    );
                  },
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: AppThemeData().iconColor,
                    fontSize: 18
                  ),
                ),
                Expanded(child: Container(),),
                if(widget.actions != null) ...widget.actions!
              ],
            ),
          ),
          if(widget.withHeaders) 
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      customIndexedButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(Routes.MUSIC_LIST);
                        },
                        icon: Icons.equalizer,
                        text: "All",
                        type: AppBarMenuOptions.All
                      ),
                      customIndexedButton(
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(Routes.SINGERS_LIST);
                        }, 
                        icon: Icons.person,
                        text: "Singers",
                        type: AppBarMenuOptions.Singers
                      ),
                      customIndexedButton(
                        onPressed: (){}, 
                        icon: Icons.album,
                        text: "Albums",
                        type: AppBarMenuOptions.Albums
                      ),
                      customIndexedButton(
                        onPressed: (){},
                        icon: Icons.library_music,
                        text: "Playlists",
                        type: AppBarMenuOptions.Playlists
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget customIndexedButton({
    required IconData icon,
    required String text,
    required Function onPressed,
    required AppBarMenuOptions type
  }) {
    return TextButton.icon(
      onPressed: (){
        if(widget.active == type) return;

        onPressed();
      },
      icon: Icon(
        icon, 
        color: type==widget.active? Colors.blue:Colors.blueGrey,
      ),
      label: Text(
        text,
        style: TextStyle(
          color:type==widget.active? Colors.blue:Colors.blueGrey,
        ),
      )
    );
  }
}