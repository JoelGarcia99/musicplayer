import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.drawer.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistMainScreen extends StatefulWidget {

  @override
  State<PlaylistMainScreen> createState() => _PlaylistMainScreenState();
}

class _PlaylistMainScreenState extends State<PlaylistMainScreen> {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      drawer: PlayerDrawer(parentContext: context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemeData().primaryButtonColor,
        child: Icon(
          Icons.add,
          color: AppThemeData().primaryButtonTextColor,
        ),
        onPressed: () {
          showPlaylistCreationDialog();
        },
      ),
      bottomSheet: Container(
        height: screenSize.height * 0.1,
        child: PlayerBottomSheet()
      ),
      body: Column(
        children: [
          PlayerAppBar(
            title: S.of(context).playlists,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ()async{
                SmartDialog.showLoading(msg: S.of(context).searching_playlists);
                await AudioCustomQuery().queryPlaylist(true);
                SmartDialog.dismiss();

                setState(() {});
              },
              child: FutureBuilder<List<PlaylistModel>>(
                future: AudioCustomQuery().queryPlaylist(),
                builder: (BuildContext context, AsyncSnapshot<List<PlaylistModel>> snapshot) {
                  if(!snapshot.hasData) {
                    // SmartDialog.showLoading(msg: S.of(context).searching_playlists);
                    return Container();
                  }
            
                  if(snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied_outlined,
                              size: 70.0,
                              color: AppThemeData().iconColor,
                            ),
                            Text(
                              S.of(context).there_are_no_items,
                              style: TextStyle(
                                color: AppThemeData().textColor,
                                fontSize: 20.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
            
                  // closing the loader that will appear while
                  // you're searching for playlists
                  // SmartDialog.dismiss();
            
                  return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 4/2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0
                    ),
                    itemCount: snapshot.data!.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.PLAYLIST_X,
                            arguments: snapshot.data![index]
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: AppThemeData().cardColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1.0,
                                offset: Offset(1.0, 2.0),
                                spreadRadius: 2.0,
                                color: Colors.black
                              )
                            ]
                          ),
                          child: Center(child: Text(snapshot.data![index].playlistName)),
                        ),
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

  void showPlaylistCreationDialog() {

    final formKey = new GlobalKey<FormState>();
    final textController = new TextEditingController();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.playlist_add),
                helperText: S.of(context).write_playlist_name
              ),
              validator: (text) {
                if((text?.isEmpty ?? true) || (text?.trim() ?? "").length == 0) {
                  return S.of(context).enter_valid_name;
                }

                return null;
              },
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: (){
                if(formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();

                  AudioCustomQuery().createPlaylist(
                    textController.text
                  ).then((success){
                    if(success) {
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  });
                }
                else {
                  SmartDialog.showToast(
                    S.of(context).enter_valid_name,
                    time: Duration(seconds: 1)
                  );
                }
              }, 
              icon: Icon(Icons.save), 
              label: Text(S.of(context).save)
            )
          ],
        );
      }, 
    );
  }
}