import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongSwitchTile extends StatefulWidget {
  final SongModel song;
  final Function(bool) onChanged;
  final bool? isActive;
  const SongSwitchTile({ required this.song, required this.onChanged, this.isActive });

  @override
  _SongSwitchTileState createState() => _SongSwitchTileState();
}

class _SongSwitchTileState extends State<SongSwitchTile> {

  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: Text(widget.song.title),
      subtitle: Text("${widget.song.album} - ${widget.song.artist}"),
      // secondary: Text(songHelper.formatDuration(Duration(milliseconds: widget.song.duration))),
      value: isActive,
      onChanged: (state) {
        widget.onChanged(state);
        setState((){
          isActive = state;
        });
      }
    );
  }
}