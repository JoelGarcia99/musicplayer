import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.searchBar.dart';

abstract class Downloader extends StatelessWidget {

  final String site;

  const Downloader({required this.site});
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      bottomSheet: PlayerBottomSheet(),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: PlayerAppBar(title: "$site downloader", withHeaders: false,)
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SearchBar()
              ],
            ),
          )
        ],
      ),
    );
  }
}