import 'package:flutter/material.dart';
import 'package:musicplayer/ui/theme.dart';

class PlayerAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actions;
  const PlayerAppBar({required this.title, this.actions });

  @override
  _PlayerAppBarState createState() => _PlayerAppBarState();
}

class _PlayerAppBarState extends State<PlayerAppBar> {

  late int selectedIndex;

  @override
  void initState() { 
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: ()=>Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_back, color: AppThemeData().iconColor)
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