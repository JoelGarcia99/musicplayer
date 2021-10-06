import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.player.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/ui/theme.dart';

import 'widget.draggable_bottom_sheet.dart';

/// This is the class where the main process is showed.
/// Here you will visualize the artwork, progress bar and
/// and control buttons.
class MainPlayerScreen extends StatelessWidget {

  late final AppThemeData theme;
  static Size? screenSize;

  static MainPlayerScreen? _instance;

  factory MainPlayerScreen() {
    if(_instance == null) {
      _instance = new MainPlayerScreen._();
    }

    return _instance!;
  }

  MainPlayerScreen._() {
    this.theme = AppThemeData();
  }

  @override
  Widget build(BuildContext context) {

    MainPlayerScreen.screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AppThemeData().getBackgroundImage(screenSize!),
        AppThemeData().getBackgroundColor(screenSize!),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _getContent(context)
        ),
        DraggableBottomSheet()
      ],
    );
    
    
  }

  Widget _getContent(BuildContext context) {
    return SafeArea(
      // child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: _buildAppBar(context),
                ),
                Container(
                  width: screenSize!.width,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: CustomPlayer(),
                  )
                ),
                Expanded(child: Container()),
              ],
            ),
      // ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: Icon(
            Icons.expand_more,
            color: AppThemeData().iconColor,
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        Text(
          S.of(context).music_player,
          style: TextStyle(
            color: AppThemeData().iconColor,
            fontSize: 18
          ),
        ),
        Expanded(child: Container(),)
      ],
    );
  }

}
