import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/settings/data.settings.dart';
import 'package:musicplayer/ui/theme.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: AppThemeData().appbarColor,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: ListView(
            children: List<Widget>.from(
              [
                ...settingsOptions.map((e) {
                  return ListTile(
                    leading: Icon(e['icon']),
                    title: Text(e['name']),
                    subtitle: Text(e['about']),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: e['onPressed'],
                    ),
                  );
                }),
                Divider(),
                ListTile(
                  leading: Icon(Icons.find_in_page),
                  title: Text("Scan for local music"),
                  subtitle: Text("Scan for music files in your local storage"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()async{
                    SmartDialog.showLoading(msg: "Loading audios");
                    await AudioCustomQuery().quearyAudios();
                    SmartDialog.dismiss();
                  },
                )
              ]
            ),
          ),
        )
      ),
    );
  }
}