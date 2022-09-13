import 'package:appshop/models/product.dart';
import 'package:appshop/pages/product_details.dart';
import 'package:appshop/utils/rating.dart';
import 'package:appshop/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoDetailSlider extends StatefulWidget {
  final data;
  final length;
  final index;
  VideoDetailSlider({Key? key, this.data, this.length, this.index}) : super(key: key);

  @override
  State<VideoDetailSlider> createState() => _VideoDetailSliderState();
}

class _VideoDetailSliderState extends State<VideoDetailSlider> {

  PageController? _controller;
  YoutubePlayerController? youtubePlayerController;


   convertUrlToId(String url, {bool trimWhitespaces = true}) {
    assert(url.isNotEmpty ?? false, 'Url cannot be empty');
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
  @override
  void initState() {
    _controller = PageController(
      initialPage: widget.index,
    );
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: LineIcon.arrowLeft(size: 30,),
          onPressed: (){
            Get.back();
          },
        ),

      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        children: List.generate(
          widget.length, (i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: youtubeHierarchy(widget.data[i].video![0].value.toString())
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    height: 140,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                        child: Image.network(widget.data[i].images[0].src))),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        ProductDetails(product: widget.data[i],)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text('View Product', style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600
                                        ),),
                                        LineIcon.angleRight(size: 15,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(widget.data[i].name, style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                          ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 12),
                         ratingWidget(widget.data[i].averageRating,
                             widget.data[i].averageRating,
                             20.0,
                             Colors.grey.shade200.withOpacity(0.2),
                             Colors.white70,
                            15.0),
                        ],
                      ),
                    ),
                  ),
                ),
               ],
            );
       })
      ),
    );
  }
  youtubeHierarchy(url) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayer(
              progressIndicatorColor: Colors.white,
              showVideoProgressIndicator: false,
              liveUIColor: Colors.black,
              progressColors: ProgressBarColors(
                playedColor: Colors.white,
                bufferedColor: Colors.grey[700],
                handleColor: Colors.white,
              ),
            controller: YoutubePlayerController(
                initialVideoId: convertUrlToId(url),
              flags: YoutubePlayerFlags(
                autoPlay: true,
                  controlsVisibleAtStart: true,
                 loop: true,
                showLiveFullscreenButton: false
              ),
            )
          ),
        ),
      ),
    );
  }
}