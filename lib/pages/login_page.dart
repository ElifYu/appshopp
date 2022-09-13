import 'dart:convert';

import 'package:appshop/api_service.dart';
import 'package:appshop/config.dart';
import 'package:appshop/pages/bottom_bar_page.dart';
import 'package:appshop/pages/forgot_password.dart';
import 'package:appshop/pages/home_page.dart';
import 'package:appshop/pages/signup_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/form_helper.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? username;
  String? password;
  APIService? apiService;


  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();



  @override
  void initState() {
    apiService = APIService();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }
  Widget _uiSetup(BuildContext context){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icons' color
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextButton(
                  onPressed: (){
                    Get.to(SignupPage());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account yet?",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16
                      ),
                      children: [
                        TextSpan(
                          text: ' Sign Up',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: color1
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text("Hi, Welcome Back! 👋", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.black87
                  ),),
                  SizedBox(height: 10),
                  Text("Hello again, you've been missed!", style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black38
                  ),),
                  SizedBox(height: MediaQuery.of(context).size.height / 15),
                  Text("Email Address", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 16
                  ),),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (input) => username = input,
                    validator: (input) => !input!.contains('@')
                        ? "Should be email" : null,
                    cursorColor: Colors.grey[800],
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
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500]
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Password", style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 16
                  ),),
                  SizedBox(height: 10),
                  TextFormField(
                    cursorColor: Colors.grey[800],
                    controller: controllerPass,
                    keyboardType: TextInputType.text,
                    validator: (input) => input!.length < 3
                        ? "Should be more than 3 character" : null,
                    obscureText: hidePassword,
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
                        hintText: 'Enter your password',
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
                        )
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          Get.to(ForgotPassword());
                        },
                        child: Text("Forgot Password", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                            fontSize: 15
                        ),),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Sign In', style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),),
                      ),
                      color: color1,
                      onPressed: (){
                        if(validateAndSave()){
                          setState(() {
                            isApiCallProcess = true;
                          });
                          apiService?.loginCustomer(controllerEmail.text, controllerPass.text).then((ret) {
                            if(ret.data != null){
                              setState(() {
                                isApiCallProcess = false;
                              });
                              snackBarSuccessful("Login Successfully", "${ret.data!.firstName}, Welcome the App Shop");
                              write(ret.data!.id.toString(), '${ret.data!.firstName} ${ret.data!.lastName}', '${ret.data!.email}',
                              "${ret.data!.firstName}", "${ret.data!.lastName}");
                              Get.offAll(BottomBarPage());
                            }
                            else{
                              setState(() {
                                isApiCallProcess = false;
                              });
                              snackBarFailed("Oops!", 'Check your user information and try again');
                            }
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  InkWell(
                    onTap: (){
                      Get.offAll(BottomBarPage());
                    },
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: "Continue as ".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600
                              ),
                              children: [
                                TextSpan(
                                  text: 'guest'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
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
