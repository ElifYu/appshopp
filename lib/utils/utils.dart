import 'package:flutter/material.dart';


class Utils{
  static void showMessage(
      BuildContext context,
      String? title,
      String? message,
      String? buttonText,
      Function? onPressed, {
        bool isConfirmationDialog = false,
        String? buttonText2 = "",
        Function? onPressed2,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title.toString().toUpperCase(),
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17
          ),),
          content: Text(message.toString(), style: TextStyle(
              fontSize: 17
          )),
          actions: [
            FlatButton(
              onPressed: (){
                return onPressed!();
              },
              child: Text(buttonText.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[800]
                  )),
            ),
            Visibility(
              visible: isConfirmationDialog,
              child: FlatButton(
                onPressed: (){
                  return onPressed2!();
                },
                child: Text(buttonText2.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800]
                    )),
              ),
            )
          ],
        );
      }
    );
  }
}

