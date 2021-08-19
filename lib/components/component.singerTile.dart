
import 'package:flutter/material.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/router/routes.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SingerTile extends StatelessWidget {

  final ArtistModel singer;

  const SingerTile({
    Key? key, required this.singer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
	margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
	padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
	decoration: BoxDecoration(
        color: AppThemeData().cardColor,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            offset: Offset(1.0, 2.0),
          )
        ]
      ),
 
      child: ListTile(
        leading: QueryArtworkWidget(
          artwork: singer.artwork,
          deviceSDK: DeviceHelper().sdk,
          id: singer.id,
          type: ArtworkType.ALBUM,
        ),
        title: Text(singer.artistName),
	subtitle: Text("${singer.numberOfAlbums} albums - ${singer.numberOfTracks} tracks"),
	trailing: IconButton(
	    icon: Icon(Icons.arrow_forward_ios),
	    onPressed: ()=>Navigator.of(context).pushNamed(Routes.SINGERS_ALBUMS, arguments: singer),
	)
      ),
    );
  }
}
