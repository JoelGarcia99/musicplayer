import 'package:on_audio_query/on_audio_query.dart';
import 'package:uuid/uuid.dart';

class PlaylistModel {

  final String name;
  final String description;
  final String creationDate;
  final List<SongModel>? songs;
  final String id;
  final int elementsOnPlaylist;

  PlaylistModel({
    this.songs,
    String? id,
    required this.name, 
    required this.description, 
    required this.creationDate, 
    required this.elementsOnPlaylist
  }):this.id = id ?? Uuid().v4();

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return new PlaylistModel(
      id: json["__id"],
      songs: json['songs'],
      name: json['name'],
      creationDate: json['creation_date'],
      description: json['description'],
      elementsOnPlaylist: json['song_count']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "__id": this.id,
      "name": this.name,
      "description": this.description,
      "creation_date": this.creationDate,
    };
  }

}