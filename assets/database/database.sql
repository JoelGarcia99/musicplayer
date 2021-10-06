create table if not exists Playlist(
    __id char(36) primary key,
    name varchar(50) default "New Playlist",
    description varchar(250) default "No description",
    creation_date varchar not null,
    artwork varchar null
);--end

create table if not exists MusicInPlaylist(
    music_id varchar not null,
    playlist_id char(36) not null,

    primary key(music_id, playlist_id)
    foreign key(playlist_id) references Playlist(__id)
        on update cascade on delete no action
);--end