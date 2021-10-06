import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.musicSwitchTile.dart';
import 'package:musicplayer/components/component.musicTile.dart';
import 'package:musicplayer/components/component.noItem.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/helper.audio_query.dart';
import 'package:musicplayer/playlist/model.playlist.dart';
import 'package:musicplayer/playlist/screen.all_playlists.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart' as audioQuery;

class PlaylistScreen extends StatelessWidget with PlaylistController{

  @override
  Widget build(BuildContext context) {

    initController(context: context);

    Map<String, dynamic> params = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    PlaylistModel model = params["model"] as PlaylistModel;
    Future<bool> Function(String)? onDelete = params["onDelete"];
    
    querySongsByPlaylist(model.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(model.name, overflow: TextOverflow.ellipsis,),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=>_deletePlaylist(
              context: context, 
              model: model,
              onDelete: onDelete
            )
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text(S.of(context).add_music),
            trailing: Icon(Icons.add, color: AppThemeData().textColor),
            onTap: ()=>onAddMusic(context, model),
          ),
          Expanded(
            child: StreamBuilder<List<audioQuery.SongModel>>(
              stream: songStream,
              builder: (context, snapshot) {
          
                if(!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
          
                if(snapshot.data!.isEmpty) {
                  return NoItemWidget();
                }
          
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MusicTile(item: snapshot.data![index]);
                  }
                );
              }
            ),
          ),
          PlayerBottomSheet()
        ],
      ),
    );
  }

  void _deletePlaylist({
    required BuildContext context, 
    required PlaylistModel model,
    Future<bool> Function(String)? onDelete
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).alert),
          content: Text(S.of(context).confirm_delete_playlist),
          actions: [
            TextButton.icon(
              icon: Icon(Icons.cancel, color: AppThemeData().iconColor),
              label: Text(
                S.of(context).cancel,
                style: TextStyle(color: AppThemeData().textColor)
              ),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton.icon(
              icon: Icon(Icons.delete, color: AppThemeData().textDangerColor,),
              label: Text(
                S.of(context).accept,
                style: TextStyle(color: AppThemeData().textDangerColor)
              ),
              onPressed: () async {
                if(onDelete != null) {
                  final response = await onDelete(model.id);

                  // closing this modal
                  Navigator.of(context).pop();

                  // returning to playlists main screen because this has
                  // been removed
                  if(response) Navigator.of(context).pop();
                }
              }
            ),
          ],
        );
      }
    );
  }

  void onAddMusic(BuildContext context, PlaylistModel model) {

    Map<int, bool> activeMap = {};

    PlaylistController().currentSongsStreamValue.forEach((item) {
      activeMap[item.id] = true;
    });

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).music_list),
          content: ListView.builder(
            itemCount: AudioCustomQuery.queryedAudios.length,
            itemBuilder: (context, index) {

              final song = AudioCustomQuery.queryedAudios[index];

              return Column(
                children: [
                  SongSwitchTile(
                    song: song,
                    isActive: activeMap.containsKey(song.id)? activeMap[song.id]:null,
                    onChanged: (state) {
                      activeMap[song.id] = state;
                    },
                  ),
                  Divider()
                ],
              );
            },
          ),
          actions: [
            TextButton.icon(
              icon: Icon(Icons.save),
              label: Text(S.of(context).save),
              onPressed: ()async{

                List<int> songsID = [];

                activeMap.forEach((key, value) {
                  if(value) songsID.add(key);
                });

                await addSongsToPlaylist(model.id, songsID);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  // void _editPlaylist(BuildContext context, PlaylistModel model, Function setState) {
  //   final formKey = new GlobalKey<FormState>();
  //   final textController = new TextEditingController();

  //   textController.text = model.playlistName;

  //   showDialog(
  //     context: context, 
  //     builder: (context) {
  //       return AlertDialog(
  //         content: Form(
  //           key: formKey,
  //           child: TextFormField(
  //             controller: textController,
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.playlist_add),
  //               helperText: S.of(context).write_playlist_name
  //             ),
  //             validator: (text) {
  //               if((text?.isEmpty ?? true) || (text?.trim() ?? "").length == 0) {
  //                 return S.of(context).enter_valid_name;
  //               }

  //               return null;
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton.icon(
  //             label: Text(S.of(context).cancel),
  //             icon: Icon(Icons.cancel),
  //             onPressed: ()=>Navigator.of(context).pop(),
  //           ),
  //           TextButton.icon(
  //             onPressed: (){
  //               if(formKey.currentState?.validate() ?? false) {
  //                 formKey.currentState?.save();

  //                 AudioCustomQuery().editPlaylistName(
  //                   model.id,
  //                   textController.text
  //                 ).then((success)async{
  //                   if(success) {
  //                     SmartDialog.showLoading();
  //                     await AudioCustomQuery().queryPlaylist();
  //                     SmartDialog.dismiss();

  //                     Navigator.of(context).pop();
  //                     setState(() {});
  //                   }
  //                 });
  //               }
  //               else {
  //                 SmartDialog.showToast(
  //                   S.of(context).enter_valid_name,
  //                   time: Duration(seconds: 1)
  //                 );
  //               }
  //             }, 
  //             icon: Icon(Icons.save), 
  //             label: Text(S.of(context).save)
  //           ),
  //         ],
  //       );
  //     }, 
  //   );
  // }
}