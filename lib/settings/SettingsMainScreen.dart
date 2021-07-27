import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/bloc/music/music_bloc.dart';
import 'package:musicplayer/player/audioQuery.dart';
import 'package:musicplayer/settings/data.settings.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MusicBloc>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: List<Widget>.from(
            [
              ...settingsOptions.map((e) {
                return ListTile(
                  leading: Icon(e['icon']),
                  title: Text(e['name']),
                  subtitle: Text(e['about']),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: e['onPressed'],
                  ),
                );
              }),
              Divider(),
              ListTile(
                leading: Icon(Icons.find_in_page),
                title: Text("Scan for local music"),
                subtitle: Text("Scan for music files in your local storage"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: ()async{
                  final List<SongModel> data = await AudioCustomQuery().quearyAudios();
                  bloc.add(AddSongs(songs: data));
                },
              )
            ]
          ),
        ),
      )
    );
  }
}