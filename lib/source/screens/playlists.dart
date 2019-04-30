
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silexcorp/source/screens/playlistmedia.dart';
import 'dart:async';

import 'package:silexcorp/utilities/global.dart' as globals;

class Playlists extends StatefulWidget {
  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {

  final PageController pageController = PageController(viewportFraction: 0.85);
  final Firestore db = Firestore.instance;
  Stream slides;
  String activeTag = 'favorite';
  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    _queryDb();

    // Set state when page changes
    pageController.addListener(() {
      int next = pageController.page.round();
      if(currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    final content = StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {

          List slideList = snap.data.toList();

          return PageView.builder(

              controller: pageController,
              itemCount: slideList.length + 1,
              itemBuilder: (context, int currentIdx) {


                if (currentIdx == 0) {
                  return _buildTagPage();
                } else if (slideList.length >= currentIdx) {
                  // Active page
                  bool active = currentIdx == currentPage;
                  return _buildStoryPage(slideList[currentIdx - 1], active, context);
                }
              }
          );
        }
    );


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: content,
      )
    );

  }

  Stream _queryDb({ String tag ='favorite' }) {

    // Make a Query
    Query query = db.collection('playlists').where('tags', arrayContains: tag);

    // Map the documents to the data payload
    slides = query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = tag;
    });

  }


  // Builder Functions
  _buildStoryPage(Map data, bool active, BuildContext context) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 50 : 100;

    return GestureDetector(
      onTap: (){
        /*Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(data['title']),
        ));*/
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaylistMedia(type: data['type'],)));
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuint,
          margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(data['cover']),
              ),

              boxShadow: [BoxShadow(color: Colors.black87, blurRadius: blur, offset: Offset(offset, offset))]
          ),
          child: Center(
              child: Text(data['title'], style: TextStyle(fontSize: 40, color: Colors.white))
          )
      )
    );

  }


  _buildTagPage() {
    return Container(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: <Widget>[
            Text('Alexander', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w100),),
            Text('Mateo', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w600),),
          ],
        ),
        Text('Playlists', style: TextStyle( color: Colors.black26 )),
        _buildButton('favorite'),
        _buildButton('reggaeton'),
        _buildButton('romantica'),
        _buildButton('variado'),
      ],
    )
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple[500] : Colors.white;
    Color colorText = tag == activeTag ? Colors.white : Colors.purple[500];
    return FlatButton(color: color, child: Text('#$tag', style: TextStyle(color: colorText),), onPressed: () => _queryDb(tag: tag));
  }

}


//// BASIC PageView

// final PageController ctrl = PageController();

// PageView(
//   // scrollDirection: Axis.vertical,
//   controller: ctrl,
//   children: [
//     Container(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Stories', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
//           Text('FILTER', style: TextStyle( color: Colors.black26 )),
//           FlatButton(child: Text('#favorites'), onPressed: () => null)
//         ],
//       )),
//       Container(color: Colors.green),
//       Container(color: Colors.blue),
//       Container(color: Colors.orange),
//       Container(color: Colors.red)
//   ]
// )


// class ReflectlySlider extends StatelessWidget {

// ReflectlySlider({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: CarouselSlider(
//         enableInfiniteScroll: true,
//         height: 400.0,
//         items: [1, 2, 3, 4, 5].map((i) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                   decoration: BoxDecoration(color: Colors.amber),
//                   child: Text(
//                     'text $i',
//                     style: TextStyle(fontSize: 16.0),
//                   ));
//             },
//           );
//         }).toList(),
//       )
//     );
//   }
// }

