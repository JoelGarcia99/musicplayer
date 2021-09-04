import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:musicplayer/data/user_preferences.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/helpers/languages_helper.dart';
import 'package:musicplayer/ui/theme.dart';

class SettingsMainScreen extends StatelessWidget {

  final UserPreferences _userPrefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).settings, 
            style: TextStyle(
              color: AppThemeData().textLightColor
            )
          ),
          backgroundColor: AppThemeData().appbarColor,
          foregroundColor: AppThemeData().textLightColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppThemeData().textLightColor),
            onPressed: ()=>Navigator.of(context).pop()
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: List<Widget>.from(
              [
                ...getMenuOpts(context).map((e) {
                  return ListTile(
                    leading: Icon(e['icon']),
                    title: Text(e['name']),
                    subtitle: Text(e['about']),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: e['onPressed']
                  );
                }),
                Divider(),
                ListTile(
                  leading: Icon(Icons.find_in_page),
                  title: Text(S.of(context).scan_local_music),
                  subtitle: Text(S.of(context).scan_music_in_storage),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()async{
                    SmartDialog.showLoading(
                      msg: S.of(context).searching_music
                    );
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

  /// [menuOpts] are the options that will be
  /// renderized in the settings menu, so, if you want
  /// to add another one, you should do it here.
  List<Map<String, dynamic>> getMenuOpts(BuildContext context) => [
    {
      'name': S.of(context).account,
      'about': S.of(context).manage_account,
      'onPressed': (){},
      'icon': Icons.manage_accounts
    },
    {
      'name': S.of(context).language,
      'about': '${S.of(context).your_current_lan_is} ${LanguageHelper.getLanNameByPrefix(_userPrefs.language)}',
      'onPressed': ()=>setLanguageDialog(context),
      'icon': Icons.language
    },
  ];

  /// Shows a modal to change your language preferences
  void setLanguageDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(
            S.of(context).choose_language, 
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: ()=>Navigator.of(context).pop(),
              child: Text(S.of(context).cancel)
            )
          ],
          content: SingleChildScrollView(
            child: Column(
              children: List<Widget>.from(AvailableLan.values.map((language){

                final prefix = LanguageHelper.getLanPrefix(language);

                return GestureDetector(
                  onTap: () {
                    
                    Intl.defaultLocale = prefix;
                    S.load(Locale(prefix)).then((_) {
                      _userPrefs.language = prefix;
                      SmartDialog.showToast(
                        S.of(context).language_changed,
                        time: Duration(seconds: 1)
                      );
                    });

                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: _userPrefs.language == prefix? 
                        AppThemeData().focusCardColo:
                        Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 5.0)
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(prefix),
                        Text(LanguageHelper.getLanName(language)),
                        _userPrefs.language == prefix?
                          Icon(Icons.check)
                          :Container(),
                      ],
                    ),
                  ),
                );

              })),
            ),
          ),
        );
      }
    );
  }
}