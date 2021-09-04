import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.player.dart';
import 'package:musicplayer/ui/theme.dart';

import 'DraggableBottomSheet.dart';

/// This is the class where the main process is showed.
/// Here you will visualize the artwork, progress bar and
/// and control buttons.
class MainPlayerScreen extends StatelessWidget {

  late final AppThemeData theme;
  static Size? screenSize;
  static BuildContext? context;

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

    MainPlayerScreen.context = context;
    MainPlayerScreen.screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AppThemeData().getBackgroundImage(screenSize!),
        AppThemeData().getBackgroundColor(screenSize!),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _getContent()
        ),
        DraggableBottomSheet()
      ],
    );
    
    
  }

  Widget _getContent() {
    return SafeArea(
      // child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: _buildAppBar(),
            ),
            // Expanded(child: Container()),
            Container(
              height: screenSize!.height*0.6,
              width: screenSize!.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPlayer(),
              )
            ),
            Expanded(child: Container()),
          ],
        ),
      // ),
    );
  }

  Widget _buildAppBar() {
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
            Navigator.of(context!).pop();
          },
        ),
        Text(
          "Music Player",
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
