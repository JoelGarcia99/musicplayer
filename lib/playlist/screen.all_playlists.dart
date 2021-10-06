import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.drawer.dart';
import 'package:musicplayer/components/component.noItem.dart';
import 'package:musicplayer/database/controller.database.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/playlist/component.playlist_card.dart';
import 'package:musicplayer/playlist/model.playlist.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart' as audioQuery;

part 'controller.playlist.dart';

class PlaylistMainScreen extends StatelessWidget with PlaylistController {
  
  PlaylistMainScreen() {
    queryPlaylists().then(print);
  }
  
  @override
  Widget build(BuildContext context) {

    initController(context: context);

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: PlayerDrawer(parentContext: context),
      bottomSheet: Container(
        height: screenSize.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: Column(
        children: [
          PlayerAppBar(
            title: S.of(context).playlists,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: AppThemeData().textColor
                ),
                onPressed: () {
                  showPlaylistCreationDialog();
                },
              ),
            ]
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ()async{
                SmartDialog.showLoading(msg: S.of(context).searching_playlists);
                await queryPlaylists();
                SmartDialog.dismiss();
              },
              child: StreamBuilder<List<PlaylistModel>>(
                stream: playlistStream,
                builder: (BuildContext context, AsyncSnapshot<List<PlaylistModel>> snapshot) {
            
                  switch(snapshot.connectionState) {
                    
                    case ConnectionState.none:
                      return CircularProgressIndicator();
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(!snapshot.hasData || snapshot.data!.isEmpty) {
                        return NoItemWidget();
                      }
                  }

                  // closing the loader that will appear while
                  // you're searching for playlists
                  // SmartDialog.dismiss();
            
                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      // childAspectRatio: 4/2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0
                    ),
                    itemCount: snapshot.data!.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlaylistCardItem(
                        model: snapshot.data![index], 
                        onDelete: deletePlaylist
                      );
                    },
                  );
            
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}