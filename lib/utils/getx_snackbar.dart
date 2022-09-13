

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

 snackBarFailed(message1, message2) {
   return Get.snackbar(
     "","",
     duration: Duration(seconds: 5),
     margin: EdgeInsets.only(top: 20, left: 15, right: 15),
     titleText: Text(message1, style: TextStyle(
         fontSize: 16,
         color: Color(0xFFB20600),
         fontWeight: FontWeight.w600
     ),),
     messageText:  Text(message2, style: TextStyle(
         fontSize: 16,
         color: Colors.grey[700],
         fontWeight: FontWeight.w400
     )),
     backgroundColor: Colors.white,
     icon: LineIcon.exclamation(color: Color(0xFFB20600), size: 30,),
     snackPosition: SnackPosition.TOP,
   );
 }


 snackBarSuccessful(message1, message2) {
   return Get.snackbar(
     "","",
     duration: Duration(seconds: 4),
     margin: EdgeInsets.only(bottom: 40, left: 15, right: 15),
     titleText: Text(message1, style: TextStyle(
         fontSize: 16,
         color: Colors.green,
         fontWeight: FontWeight.w600
     ),),
     messageText: Text(message2,
         style: TextStyle(
             fontSize: 16,
             color: Colors.grey[700],
             fontWeight: FontWeight.w400
         )),
     backgroundColor: Colors.white,
     icon: LineIcon.check(color: Colors.green, size: 25,),
     snackPosition: SnackPosition.BOTTOM,

   );
 }

 snackBarWarning(message1, message2) {
  return Get.snackbar(
    "","",
    duration: Duration(seconds: 4),
    margin: EdgeInsets.only(top: 20, left: 15, right: 15),
    titleText: Text(message1, style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
        fontWeight: FontWeight.w600
    ),),
    messageText: Text(message2,
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w400
        )),
    backgroundColor: Colors.white,
    icon: LineIcon.exclamation(color: Colors.deepOrangeAccent, size: 25,),
    snackPosition: SnackPosition.TOP,

  );

}


snackBarLoading(message1, message2) {
  return Get.snackbar(
    "","",
    duration: Duration(seconds: 3),
    margin: EdgeInsets.only(top: 20, left: 15, right: 15),
    titleText: Text(message1, style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
        fontWeight: FontWeight.w600
    ),),
    messageText: Text(message2,
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w400
        )),
    backgroundColor: Colors.white,
    icon: CupertinoActivityIndicator(),
    snackPosition: SnackPosition.TOP,

  );

}