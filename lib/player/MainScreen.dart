import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayer/ui/theme.dart';

import 'components/component.player.dart';

class MainPlayerScreen extends StatelessWidget {

  late final AppThemeData theme;
  late final Size screenSize;
  late final BuildContext context;

  MainPlayerScreen() {
    this.theme = AppThemeData();
  }

  @override
  Widget build(BuildContext context) {

    this.context = context;
    this.screenSize = MediaQuery.of(context).size;


    return Scaffold(
      body: Stack(
        children: [
          AppThemeData().getBackgroundImage(screenSize),
          AppThemeData().getBackgroundColor(screenSize),
          Container(
            height: screenSize.height,
            child: _getContent()
          )
        ],
      )
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
            Expanded(child: Container()),
            Container(
              height: screenSize.height*0.6,
              width: screenSize.width,
              child: CustomPlayer()
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
            Navigator.of(context).pop();
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