part of 'SettingsMainScreen.dart';

class MenuSettingsItems {

  static MenuSettingsItems? _instance;

  factory MenuSettingsItems() {
    if(_instance == null) {
      _instance = MenuSettingsItems._();
    }

    return _instance!;
  }

  MenuSettingsItems._();

  /// [menuOpts] are the options that will be
  /// renderized in the settings menu, so, if you want
  /// to add another one, you should do it here.
  List<Map<String, dynamic>> getMenuOpts(BuildContext context) => [
    {
      'name': S.of(context).language,
      'about': '${S.of(context).your_current_lan_is} ${LanguageHelper.getLanNameByPrefix(UserPreferences().language)}',
      'onPressed': ()=>setLanguageDialog(context),
      'icon': Icons.language
    },
  ];

  List<Map<String, dynamic>> getSecondaryMenuOpts(BuildContext context) => [
    {
      'name': S.of(context).scan_local_music,
      'about': S.of(context).scan_music_in_storage,
      'onPressed': ()async{
        SmartDialog.showLoading(
          msg: S.of(context).searching_music
        );
        await AudioCustomQuery().quearyAudios(false, '', true);
        SmartDialog.dismiss();
      },
      'icon': Icons.find_in_page
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
            style: TextStyle(
              color: AppThemeData().textColor
            ),
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
                      UserPreferences().language = prefix;
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
                      color: UserPreferences().language == prefix? 
                        AppThemeData().focusCardColo:
                        AppThemeData().cardColor.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[850]!,
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
                        Text(
                          prefix,
                          style: TextStyle(
                            color: 
                              UserPreferences().language == prefix?
                              AppThemeData().textLightColor:
                              AppThemeData().textColor
                          )
                        ),
                        Text(
                          LanguageHelper.getLanName(language),
                          style: TextStyle(
                            color: 
                              UserPreferences().language == prefix?
                              AppThemeData().textLightColor:
                              AppThemeData().textColor
                          )
                        ),
                        UserPreferences().language == prefix?
                          Icon(
                            Icons.check,
                            color: 
                              UserPreferences().language == prefix?
                              AppThemeData().textLightColor:
                              AppThemeData().textColor
                          )
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