import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class InteractiveImage extends StatefulWidget {
  final image;
  InteractiveImage({Key? key, this.image,}) : super(key: key);

  @override
  _InteractiveImageState createState() => new _InteractiveImageState();
}

class _InteractiveImageState extends State<InteractiveImage> {
  _InteractiveImageState();


  double _scale = 1.0;
  double _previousScale = 1.0;
  GlobalKey key = GlobalKey(); // <--- HE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 0.3,
        titleSpacing: 5,
        backgroundColor: Colors.black54,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white70
        ),
        toolbarHeight: 55,
      ),
      body: PinchZoom(
        child: Image.network(widget.image),
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: (){
          print('Start zooming');
          },
        onZoomEnd: (){
          print('Stop zooming');
        },
      ),
    );
  }
}