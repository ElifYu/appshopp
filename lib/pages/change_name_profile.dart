import 'dart:convert';
import 'dart:io';

import 'package:appshop/config.dart';
import 'package:appshop/pages/delete_account_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:http/http.dart' as http;

import '../utils/getx_snackbar.dart';

class WidgetChangeName extends StatefulWidget {
  const WidgetChangeName({Key? key}) : super(key: key);

  @override
  _WidgetChangeNameState createState() => _WidgetChangeNameState();
}

class _WidgetChangeNameState extends State<WidgetChangeName> {

  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool saveLoading = false;

  updateUserInf(userName, userFirstName, userLastName) async{
    await storage.write(key: "userName", value: userName);
    await storage.write(key: "userFirstName", value: userFirstName);
    await storage.write(key: "userLastName", value: userLastName);
    read().then((value) => setState((){}));
  }

  changeUserName() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('PUT', Uri.parse(Config.url + 'customers/${Config.userID}?consumer_key=${Config.key}&consumer_secret=${Config.secret}'));
    request.body = json.encode({
      "first_name": controllerFirstName.text,
      "last_name":  controllerLastName.text,
      "billing": {
        "first_name":  controllerFirstName.text,
        "last_name": controllerLastName.text,
      },
      "shipping": {
        "first_name":  controllerFirstName.text,
        "last_name": controllerLastName.text,
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        saveLoading = false;
      });
      snackBarSuccessful("Successfully Changed", "Your name has been successfully changed");
      updateUserInf('${controllerFirstName.text + ' ' + controllerLastName.text}',
          controllerFirstName.text,
          controllerLastName.text
      );
    }
    else {
      setState(() {
        saveLoading = false;
      });
      snackBarFailed(response.statusCode.toString(), "Your name couldn't be changed");
    }
  }

  @override
  void initState() {
    super.initState();
    read().then((value) {
      setState(() {
        controllerFirstName = TextEditingController(text: userFirstName);
        controllerLastName = TextEditingController(text: userLastName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: saveLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.3,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: LineIcon.arrowLeft(
              color: Colors.black87,
              size: 28,
            ),
            onPressed: (){
              Get.back();
            },
          ),
          title:  Text("My User Information", style: TextStyle(
              color: Colors.black87,
              fontSize: 17
          ),),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      top: BorderSide(color: Colors.grey.shade300),
                    )
                  ),
                  padding: const EdgeInsets.all(14.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text("First Name", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,

                            ),),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controllerFirstName,
                              validator: (input) => input!.isEmpty
                                  ? "Please enter your first name" : null,
                              cursorColor: Colors.grey[800],
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter your first name',
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text("Last Name", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,

                            ),),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controllerLastName,
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) => input!.isEmpty
                                  ? "Please enter your last name" : null,
                              cursorColor: Colors.grey[800],
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter your last name',
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text("Email", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,

                            ),),
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                  color: Colors.grey[600]
                              ),
                              controller: controllerEmail..text = userEmail,
                              enabled: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: FlatButton(
                      onPressed: (){
                        if(validateAndSave()){
                          setState(() {
                            saveLoading = true;
                          });
                          changeUserName();
                        }
                      },
                      child: Text("Save", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),),
                      color: color1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.only(top: 11, bottom: 11),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: (){
                      Get.to(DeleteUserAccount());
                    },
                    child: Text('Remove Account', style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave(){
    final form = globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}
