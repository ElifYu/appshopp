import 'dart:io';
import 'dart:typed_data';

import 'package:appshop/api_service.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/videos_detail_slider.dart';
import 'package:appshop/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WidgetHomeVideo extends StatefulWidget {
  String? labelName;
  String? tagId;
  WidgetHomeVideo({Key? key, this.labelName, this.tagId}) : super(key: key);

  @override
  _WidgetHomeVideoState createState() => _WidgetHomeVideoState();
}

class _WidgetHomeVideoState extends State<WidgetHomeVideo> {

  APIService? apiService;


/*
   _fetchMetadata(data.images![0].src);
            print(metaData);
 */

  String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.max,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  var thumbnailUrl;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, bottom: 0),
              child: Text('Videos',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
            ),

          ],
        ),
        _productsList(),
      ],
    );
  }
  Widget _productsList() {
    return FutureBuilder(
        future: apiService!.getProducts(tagName: this.widget.tagId.toString(), sortOrder: "desc"),//
        builder: (BuildContext context, AsyncSnapshot<List<Product>> model){
          if(model.hasData){
            return _buildList(model.data);
          }
          return Container(
            height: 250,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (BuildContext context, int index){
                  return Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade300,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 280,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      )
                  );
                }
            ),
          );
        }
    );
  }

  Widget _buildList(List<Product>? items){
    return Container(
      height: 250,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: items!.length,
          itemBuilder: (context, index){
            var data = items[index];
            String? videoId = convertUrlToId(data.video![0].value.toString());
            thumbnailUrl = getThumbnail(videoId: videoId ?? "");
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: (){

                Get.to(VideoDetailSlider(
                    data: items,
                    index: index,
                    length: items.length
                ));

               // print(data);
              },
              child: Stack(
                children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: thumbnailUrl,
                      fit: BoxFit.cover, height: 280,
                      width: 170,
                      placeholder: (context, url) => Container(color: Colors.white,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 40,)
                    ),
                  ),
                ),

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        child: Text(data.name.toString(), style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 20.0,
                                color: Colors.black38,
                              ),
                          ],
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                        ), maxLines: 2, overflow: TextOverflow.ellipsis,),
                      )
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}