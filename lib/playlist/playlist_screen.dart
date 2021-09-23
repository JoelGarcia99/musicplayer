import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:musicplayer/components/component.bottomSheet.dart';
import 'package:musicplayer/components/component.noItem.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> params = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    PlaylistModel model = params["model"] as PlaylistModel;
    Function setState = params["setState"] as Function;

    return Scaffold(
      appBar: AppBar(
        title: Text(model.playlistName, overflow: TextOverflow.ellipsis,),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=>_deletePlaylist(context, model, setState)
          ),
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: ()=>_editPlaylist(context, model, setState)
          // ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text(S.of(context).add_music),
            trailing: Icon(Icons.add, color: AppThemeData().textColor),
          ),
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: AudioCustomQuery().queryMusicByPlaylist(model.id),
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
                    return Text(snapshot.data![0].title);
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

  void _deletePlaylist(BuildContext context, PlaylistModel model, Function setState) {
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
              onPressed: ()async{
                SmartDialog.showLoading();
                await AudioCustomQuery().removePlaylist(model.id);
                await AudioCustomQuery().queryPlaylist(true);
                SmartDialog.dismiss();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                
                setState((){
                  SmartDialog.showToast(
                    S.of(context).playlist_was_deleted,
                    time: Duration(seconds: 1)
                  );
                });

              },
            ),
          ],
        );
      }
    );
  }

  void _editPlaylist(BuildContext context, PlaylistModel model, Function setState) {
    final formKey = new GlobalKey<FormState>();
    final textController = new TextEditingController();

    textController.text = model.playlistName;

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
              label: Text(S.of(context).cancel),
              icon: Icon(Icons.cancel),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton.icon(
              onPressed: (){
                if(formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();

                  AudioCustomQuery().editPlaylistName(
                    model.id,
                    textController.text
                  ).then((success)async{
                    if(success) {
                      SmartDialog.showLoading();
                      await AudioCustomQuery().queryPlaylist();
                      SmartDialog.dismiss();

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
            ),
          ],
        );
      }, 
    );
  }
}