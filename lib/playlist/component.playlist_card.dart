import 'package:flutter/material.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/playlist/model.playlist.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';

enum _menuOpts {
  Delete,
  Edit,
  Open
}

String _optsToString(BuildContext context, _menuOpts opt) {
  switch(opt) {
    case _menuOpts.Delete: return S.of(context).delete;
    case _menuOpts.Edit: return S.of(context).edit;
    case _menuOpts.Open: return S.of(context).open;
  }
}

IconData _optsToIcon(_menuOpts opt) {
  switch(opt) {
    
    case _menuOpts.Delete: return Icons.delete;
    case _menuOpts.Edit: return Icons.edit;
    case _menuOpts.Open: return Icons.info;
  }
}

class PlaylistCardItem extends StatelessWidget {

  final PlaylistModel model;
  final Future<bool> Function(String) onDelete;

  const PlaylistCardItem({
    Key? key, 
    required this.model, 
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: ()=>onLongTap(context),
      onTap: ()=>onTap(context),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(S.of(context).number_songs + " ${model.elementsOnPlaylist}"),
            Divider(),
            Text(
              model.description,
              style: TextStyle(
                fontSize: 12
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLongTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${model.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.from(_menuOpts.values.map((opt){
              return ListTile(
                title: Text(_optsToString(context, opt)),
                leading: Icon(_optsToIcon(opt)),
                onTap: () async {
                  switch(opt) {
                    case _menuOpts.Delete: _deletePlaylist(context: context); break;
                    case _menuOpts.Edit:
                    case _menuOpts.Open: onTap(context); break;
                  }
                },
              );
            })),
          ),
        );
      }
    );
  }

  void onTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      Routes.PLAYLIST_X,
      arguments: {
        "model": model,
        "onDelete": onDelete,
      }
    );
  }

  void _deletePlaylist({
    required BuildContext context,
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
                await onDelete(model.id);

                // closing this modal
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      }
    );
  }
}