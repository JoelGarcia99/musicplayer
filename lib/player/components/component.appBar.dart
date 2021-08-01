import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';

class PlayerAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actions;
  final bool withHeaders;
  const PlayerAppBar({required this.title, this.actions, this.withHeaders = false});

  @override
  _PlayerAppBarState createState() => _PlayerAppBarState();
}

class _PlayerAppBarState extends State<PlayerAppBar> {

  late int selectedIndex;
  late Size screenSize;

  @override
  void initState() { 
    super.initState();
    selectedIndex = 0;
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
                                    Navigator.of(context).pushNamed(Routes.MUSIC_LIST);
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
                        onPressed: (){}, 
                        icon: Icons.equalizer,
                        text: "All",
                        index: 0
                      ),
                      customIndexedButton(
                        onPressed: (){}, 
                        icon: Icons.person,
                        text: "Singers",
                        index: 1
                      ),
                      customIndexedButton(
                        onPressed: (){}, 
                        icon: Icons.album,
                        text: "Albums",
                        index: 2
                      ),
                      customIndexedButton(
                        onPressed: (){}, 
                        icon: Icons.library_music,
                        text: "Playlists",
                        index: 3
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
    required int index
  }) {
    return TextButton.icon(
      onPressed: (){
        setState(() {
          selectedIndex = index;
          onPressed();
        });
      }, 
      icon: Icon(icon, color: selectedIndex==index? Colors.blue:Colors.blueGrey,),
      label: Text(
        text,
        style: TextStyle(
          color: selectedIndex==index? Colors.blue:Colors.blueGrey,
        ),
      )
    );
  }
}