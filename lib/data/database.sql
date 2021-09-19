create database if not exists musicplayer;

create table if not exists Playlist(
    __id integer auto_increment primary key,
    name varchar(50) default "New Playlist",
    description varchar(250) default "No description"
);