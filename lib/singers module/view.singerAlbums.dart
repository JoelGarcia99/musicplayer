
import 'package:flutter/material.dart';
import 'package:musicplayer/components/component.albumTile.dart';
import 'package:musicplayer/components/component.appBar.dart';
import 'package:musicplayer/helpers/DeviceHelper.dart';
import 'package:musicplayer/helpers/audioQuery.dart';
import 'package:musicplayer/ui/theme.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SingerAlbums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    ArtistModel singer = (ModalRoute.of(context)?.settings.arguments as ArtistModel);

    return Scaffold(
	body: Stack(
	    children: [
	      AppThemeData().getBackgroundImage(size),
	      AppThemeData().getBackgroundColor(size),
	      _content(singer, size, context)
	    ],
	)
    );
  }

  Widget _content(ArtistModel singer, Size size, BuildContext context) {
    return Column(
	children: [
	  PlayerAppBar(title: "${singer.artistName} albums", leading: IconButton(
		  icon: Icon(Icons.arrow_back, color: AppThemeData().iconColor),
		    onPressed: ()=>Navigator.of(context).pop()
	    )),
	    _singerBackground(singer, size),
	    Expanded(
		child: FutureBuilder(
		    future: AudioCustomQuery().queryAlbums(singer: singer.artistName),
		    builder: (scontext, AsyncSnapshot<List<AlbumModel>> snapshot) {

		      if(!snapshot.hasData) {
			return Center(child: CircularProgressIndicator(),);
		      }

		      final List<Widget> widgets = [
			...List<Widget>.from(snapshot.data!.map((e) => AlbumTile(album: e)))
		      ];

		      return ListView.builder(
			  itemCount: widgets.length,
			  itemBuilder: (context, index) {
			    return widgets[index];
			  }
		      );
		    }
		)
	    )
	],
    );
  }

  Widget _singerBackground(ArtistModel singer, Size size) {
    return Container(
	child: Stack(
	    children: [
	      QueryArtworkWidget(
		  id: singer.id,
		  type: ArtworkType.AUDIO,
		  artwork: singer.artwork,
		  deviceSDK: DeviceHelper().sdk,
		  nullArtworkWidget: Container(
		      height: size.width * 0.7, 
		      width: size.width,
		      child: Icon(Icons.music_note, size: size.width * 0.5),
		  ),
		  artworkHeight: size.width * 0.7, 
	      ),
	      Container(
		  height: size.width * 0.7, 
		  width: size.width, 
		  padding: EdgeInsets.all(10.0),
		  color: Colors.black.withOpacity(0.6),
		  child: Column(
		      mainAxisSize: MainAxisSize.max,
		      mainAxisAlignment: MainAxisAlignment.end,
		      children: [
			Row(
			    children: [
			      Text("${singer.numberOfAlbums} albums\t", style: TextStyle(color: AppThemeData().iconColor)),
			      SizedBox(width: 20.0),
			      Text("${singer.numberOfTracks} tracks\t", style: TextStyle(color: AppThemeData().iconColor)),
			    ],
			)
		      ]
		  )
	      )
	    ],
	),
    );

  }
}
