import 'dart:convert';

import 'package:appshop/config.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  final userEmail;
  const ResetPasswordPage({Key? key, this.userEmail}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool hidePasswordNewPass = true;

  TextEditingController controllerPassNew = TextEditingController();
  TextEditingController controllerPassAgain = TextEditingController();

  bool loading = true;

  Future resetUserPassword() async{
    try{
      var response = await http.post(Uri.parse(Config.change_passwordURL),
          body: {
            "user_id": widget.userEmail,
            "new_password": controllerPassAgain.text
          }
      );

      var js = json.decode(response.body);
      print(js);
      if(js['status'] == '1'){
        snackBarSuccessful("Password Changed!", "Your password has been successfully changed");
        setState(() {
          loading = true;
        });
        await Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
      else{
        snackBarFailed("Oops!", "This password same as your current password");
        setState(() {
          loading = true;
        });
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        snackBarFailed("Oops!", e.message);
        print(e.response!.statusCode);
        setState(() {
          loading = true;
        });
      }
      else{
        print(e.message);
        snackBarFailed("Oops!", e.message);
        setState(() {
          loading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: !loading,
      opacity: 0.3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[50],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Reset Password', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: 15),
                  Text("Create a password at least 6 characters long.", style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                  ), textAlign: TextAlign.center,),
                  SizedBox(height: 35),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (input) => input!.length < 3
                        ? "Should be more than 3 character" : null,
                    obscureText: hidePassword,
                    controller: controllerPassNew,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]
                      ),
                      suffixIcon: IconButton(
                        icon: !hidePassword ? LineIcon.eye() : LineIcon.eyeSlash(),
                        onPressed: (){
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: controllerPassAgain,
                    keyboardType: TextInputType.text,
                    validator: (input) => input!.length < 3
                        ? "Should be more than 3 character" : null,
                    obscureText: hidePasswordNewPass,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Enter your new password again',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500]
                      ),
                      suffixIcon: IconButton(
                        icon: !hidePasswordNewPass ? LineIcon.eye() : LineIcon.eyeSlash(),
                        onPressed: (){
                          setState(() {
                            hidePasswordNewPass = !hidePasswordNewPass;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Reset Password', style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),),
                      ),
                      color: color1,
                      onPressed: () async{
                        if(validateAndSave()) {
                          if(controllerPassNew.text != controllerPassAgain.text){
                            snackBarFailed("Password Does Not Match", "The new password and the duplicate password do not match");
                          }
                          else{
                            setState(() {
                              loading = false;
                            });
                            resetUserPassword();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
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
