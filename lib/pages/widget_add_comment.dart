import 'dart:convert';
import 'dart:io';
import 'package:appshop/config.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddComment extends StatefulWidget {
  final productId;
  const AddComment({Key? key, this.productId}) : super(key: key);

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {

  double rating = 3.5;

  TextEditingController controllerComment = TextEditingController();
  var authToken = base64.encode(utf8.encode(Config.key + ":" + Config.secret),
  );

  bool sendButton = true;
  bool userNotLogin = false;


  Future<List> postComment() async {

    List data = [];

    try{
      String url = "${Config.urlWebSite}/wp-json/wc/v3/products/reviews";

      var response = await Dio().post(
          url,
          data: {
            "product_id": widget.productId,
            "review": controllerComment.text,
            "reviewer": userName,
            "reviewer_email": userEmail,
            "rating": rating.toInt()
          },
          options: Options(
              headers: {
                HttpHeaders.authorizationHeader : 'Basic $authToken',
                HttpHeaders.contentTypeHeader : "application/json"
              }
          )
      );

      if(response.statusCode == 201){
        print(response.statusCode);
        data = [response.statusCode];
        snackBarSuccessful("Your review has been sent", "Your review will be published after approval");
      }
      else{
        snackBarWarning("Oops!", "You have already reviewed this product before");
        setState(() {
          sendButton = true;
        });
      }

    } on DioError catch (e) {
      print(e.response!.statusCode);
      snackBarWarning("Oops!", "You have already reviewed this product before");
      setState(() {
        sendButton = true;
      });
    }
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
    if(jwt == null){
      setState(() {
        userNotLogin = true;
      });
    }
    else{
      setState(() {
        userNotLogin = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return userNotLogin == true ?
    UserNotSignIn() :
    Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: (){
                Get.back();
              },
              child: Text('Cancel', style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16
              ),),
            ),
            Text("Rate & Review", style: TextStyle(
                color: Colors.black87,
              fontSize: 17
            ),),
            TextButton(
              onPressed: (){
                if (controllerComment.text.isEmpty) {
                  snackBarWarning("Please fill in all fields", "Enter your review in the box");
                }
                else {
                  read();
                  setState(() {
                    sendButton = false;
                  });
                  postComment().then((value) {
                    if(value.contains(201)){
                      setState(() {
                        sendButton = true;
                      });
                    }
                  });
                }
              },
              child: Text('Send', style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                fontWeight: FontWeight.w600
              ),),
            ),
          ],
        ),
      ),
      body: ProgressHUD(
        inAsyncCall: !sendButton,
        opacity: 0.3,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              StarRating(
                  rating: rating,
                  onRatingChanged: (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                    print(rating);
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Divider(height: 0, thickness: 1.2,),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: controllerComment,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Write a review',
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int? starCount;
  final double? rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating!) {
      icon = new Icon(
        Icons.star_border,
        size: 25,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating! - 1 && index < rating!) {
      icon = Icon(
          size: 25,
        Icons.star_half,
        color: color ?? color1
      );
    } else {
      icon = Icon(
          size: 25,
        Icons.star,
        color: color ?? color1
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 10,
      minLeadingWidth: 10,
      leading: Text('Rate:', style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16
      ),),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(starCount!, (index) => Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: buildStar(context, index),
          ),
          ),)
    );
  }
}