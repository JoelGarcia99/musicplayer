
import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';


class AlbumTile extends StatelessWidget {

  final AlbumModel album;

  const AlbumTile({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
	padding: const EdgeInsets.all(10.0),
	margin: const EdgeInsets.all(5.0),
	decoration: BoxDecoration(
	    color: AppThemeData().cardColor,
	    borderRadius: BorderRadius.circular(10.0)
	),
	child: ListTile(
	    title: Text(album.albumName),
	    subtitle: Text("${album.numOfSongs} tracks"),
	    leading: QueryArtworkWidget(
	      id: album.id, 
	      artwork: album.artwork, 
	      deviceSDK: DeviceHelper().sdk,
	      type: ArtworkType.ALBUM,
	      
	    )
	),
    );
  }

}
