
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:media_player/ui.dart';

class PlaylistMedia extends StatefulWidget {
  final bool type;
  PlaylistMedia({this.type});
  @override
  _PlaylistMediaState createState() => _PlaylistMediaState();
}

class _PlaylistMediaState extends State<PlaylistMedia> {
  MediaPlayer player;
  Playlist playlist;
  int currentPlaylistIndex;
  var currentSource;

  //final Firestore db = Firestore.instance;
  //Stream slides;
  String activeTag = 'favorites';
  List<MediaFile> mediaFiles = List();


  @override
  void initState() {
    player = MediaPlayerPlugin.create(isBackground: true, showNotification: true);

    initMediaPlayer();


    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<Null> initMediaPlayer() async {
    if(widget.type){
      await Firestore.instance.collection('tracks').where('type', isEqualTo: 'audio').snapshots().listen((data) => data.documents.forEach((doc){
        mediaFiles.add( MediaFile(
          title: doc['title'],
          type: doc['type'],
          source: doc['source'],
          desc: doc['desc'],
        ));
      })
      );
    }else{
      await Firestore.instance.collection('tracks').where('type', isEqualTo: 'video').snapshots().listen((data) => data.documents.forEach((doc){
        mediaFiles.add( MediaFile(
          title: doc['title'],
          type: doc['type'],
          source: doc['source'],
          desc: doc['desc'],
        ));
      })
      );
    }

    /*var userQuery = await Firestore.instance.collection('tracks');//.where('type', isEqualTo: 'audio');
    userQuery.getDocuments().then((data) async {
      data.documents.map((doc){
        mediaFiles.add( MediaFile(
          title: doc['title'],
          type: doc['type'],
          source: doc['source'],
          desc: doc['desc'],
        ));
      });
    });*/

    playlist = new Playlist(mediaFiles);

    initVideoPlayer();

  }

  void initVideoPlayer() async {
    await player.initialize();

    player.valueNotifier.addListener(() {
      this.currentPlaylistIndex = player.valueNotifier.value.currentIndex;
      this.currentSource = player.valueNotifier.value.source;
      setState(() {});
    });

    /*if (widget.source != null) {
      await player.setSource(widget.source);
    }*/

    if (playlist != null) {
      await player.setPlaylist(playlist);
      player.setLooping(true);
    }
    player.play();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(children: [
        widget.type ? Container( child: Image.network('https://cdnb.artstation.com/p/assets/images/images/008/124/939/smaller_square/alexander-mateo-render-26.jpg?1510648015', fit: BoxFit.fitWidth,height: 210.0, width: double.infinity,)/*Image.asset('assets/app/logo.png')*/,) : VideoPlayerView(player),
        VideoProgressIndicator(
          player,
          allowScrubbing: true,
          padding: EdgeInsets.symmetric(vertical:5.0),
        ),
        buildText(),
        buildButtons(),
        playlistView(),
      ]),
    );
  }

  Row buildText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40.0,
          alignment: Alignment.center,
          child: Text(
            (this.currentSource != null && this.currentPlaylistIndex != 0) ? this.currentSource.mediaFiles[this.currentPlaylistIndex].title : 'Alexander Mateo',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ), /*Container(
          height: 60.0,
          alignment: Alignment.center,
          child: Text(playlist.count.toString() + ' media files'),
        )*/
      ],
    );
  }

  Row buildButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Icon(Icons.skip_previous, size: 40.0,),
          onPressed: () {
            player.playPrev();
          },
        ),
        FlatButton(
          child: Icon(Icons.play_arrow, size: 40.0,),
          onPressed: () {
            player.play();
          },
        ),
        FlatButton(
          child: Icon(Icons.pause, size: 40.0,),
          onPressed: () {
            player.pause();
          },
        ),
        FlatButton(
          child: Icon(Icons.skip_next, size: 40.0,),
          onPressed: () {
            player.playNext();
          },
        ),
      ],
    );
  }

  Widget playlistView() {
    return Expanded(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: playlist != null ? playlist.count : 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://cdnb.artstation.com/p/assets/images/images/008/124/939/smaller_square/alexander-mateo-render-26.jpg?1510648015"),
                  radius: 25.0,
                ),
                title: Text(this.currentSource.mediaFiles[index].title),
                subtitle: new Text(this.currentSource.mediaFiles[index].desc),
                trailing: IconButton(
                    onPressed: () {
                      this.player.playAt(index);
                    },
                    icon: Icon(
                      (this.currentPlaylistIndex == index)
                          ? Icons.pause
                          : Icons.play_arrow,
                    )),
              );
            },
          )
        )
    );
  }

}
