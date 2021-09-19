import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:musicplayer/data/user_preferences.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/helpers/languages_helper.dart';
import 'package:musicplayer/ui/theme.dart';

part 'data.menuSettings.dart';

class SettingsMainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppThemeData().backgroundColor,
        appBar: AppBar(
          title: Text(
            S.of(context).settings, 
            style: TextStyle(
              color: AppThemeData().textColor
            )
          ),
          backgroundColor: AppThemeData().backgroundColor,
          foregroundColor: AppThemeData().textColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppThemeData().iconColor),
            onPressed: ()=>Navigator.of(context).pop()
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: List<Widget>.from(
              [
                ...MenuSettingsItems().getMenuOpts(context).map((e) {
                  return ListTile(
                    leading: Icon(e['icon'], color: AppThemeData().iconColor,),
                    title: Text(
                      e['name'],
                      style: TextStyle(
                        color: AppThemeData().textColor
                      ),
                    ),
                    subtitle: Text(
                      e['about'],
                      style: TextStyle(
                        color: AppThemeData().textColor
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppThemeData().iconColor,
                    ),
                    onTap: e['onPressed']
                  );
                }),
                Divider(
                  color: Colors.grey,
                ),
                ...MenuSettingsItems().getSecondaryMenuOpts(context).map((e) {
                  return ListTile(
                    leading: Icon(e['icon'], color: AppThemeData().iconColor,),
                    title: Text(
                      e['name'],
                      style: TextStyle(
                        color: AppThemeData().textColor
                      ),
                    ),
                    subtitle: Text(
                      e['about'],
                      style: TextStyle(
                        color: AppThemeData().textColor
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppThemeData().iconColor,
                    ),
                    onTap: e['onPressed']
                  );
                })
              ]
            ),
          ),
        )
      ),
    );
  }

  
}