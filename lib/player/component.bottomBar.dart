import 'package:flutter/material.dart';
import 'package:musicplayer/ui/theme.dart';

class PlayerBottomBar extends StatelessWidget {
  const PlayerBottomBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.skip_previous, color: AppThemeData().iconColor,
            size: 40.0,
          ),
          onPressed: (){}, 
        ),
        SizedBox(width: 10.0,),
        IconButton(
          icon: Icon(
            Icons.play_arrow, color: AppThemeData().iconColor,
            size: 40.0,
          ),
          onPressed: (){},
        ),
        SizedBox(width: 10.0,),
        IconButton(
          icon: Icon(
            Icons.skip_next, color: AppThemeData().iconColor,
            size: 40.0,
          ),
          onPressed: (){}, 
        ),
      ],
    );
  }
}