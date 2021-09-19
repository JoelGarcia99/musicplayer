import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PlaylistModel model = (ModalRoute.of(context)!.settings.arguments as PlaylistModel);

    return Scaffold(
      appBar: AppBar(
        title: Text(model.playlistName, overflow: TextOverflow.ellipsis,),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Text(model.playlistName);
        }
      ),
    );
  }
}