import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/components/component.drawer.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';

enum AppBarMenuOptions { All, Singers, Albums, Playlists }

class PlayerAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool withHeaders;
  final AppBarMenuOptions active;
  const PlayerAppBar(
      {required this.title,
      this.leading,
      this.actions,
      this.withHeaders = false,
      this.active = AppBarMenuOptions.All});

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
                widget.leading ??
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: AppThemeData().iconColor,
                      ),
                      onPressed: () {
                        SmartDialog.show(
                            clickBgDismissTemp: true,
                            alignmentTemp: Alignment.centerLeft,
                            widget: PlayerDrawer(
                              parentContext: context,
                            ));
                      },
                    ),
                Text(
                  widget.title,
                  style:
                      TextStyle(color: AppThemeData().iconColor, fontSize: 18),
                ),
                Expanded(
                  child: Container(),
                ),
                if (widget.actions != null) ...[
                  ...widget.actions!,
                  IconButton(
                      icon: Icon(Icons.settings, color: AppThemeData().iconColor),
                      onPressed: ()=>Navigator.of(context).pushNamed(Routes.SETTINGS),
                  )
                ]
                else
                  IconButton(
                      icon: Icon(Icons.settings, color: AppThemeData().iconColor),
                      onPressed: ()=>Navigator.of(context).pushNamed(Routes.SETTINGS),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customIndexedButton(
      {required IconData icon,
      required String text,
      required Function onPressed,
      required AppBarMenuOptions type}) {
    return TextButton.icon(
        onPressed: () {
          if (widget.active == type) return;

          onPressed();
        },
        icon: Icon(
          icon,
          color: type == widget.active ? Colors.blue : Colors.blueGrey,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: type == widget.active ? Colors.blue : Colors.blueGrey,
          ),
        ));
  }
}
