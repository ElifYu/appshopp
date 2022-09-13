// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:appshop/api_service.dart';
import 'package:appshop/config.dart';
import 'package:appshop/pages/reset_pass.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../utils/getx_snackbar.dart';



var sendThisNumber;
var textFieldEnable = true;



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with TickerProviderStateMixin{

  APIService apiService;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String email;
  TextEditingController controllerEmail = TextEditingController();

  bool loading = true;
  bool trueCode = false;

  randomNumber(){
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    setState(() {
      sendThisNumber = code;
    });
    sendEmailToUser(sendThisNumber);
    print(sendThisNumber);
  }


  Future checkUserEmail() async{
    try{
      var response = await http.post(Uri.parse(Config.forgot_passwordURL),
          body: {
            "login": controllerEmail.text
          }
      );

      var js = json.decode(response.body);
      print(js);
      if(js['status'] == '1'){
        randomNumber();
      }
      else{
        setState(() {
          loading = true;
        });
        snackBarFailed("Oops!", "No account found for this email");
      }
    } on DioError catch (e) {
      if(e.response.statusCode == 404){
        print(e.response.statusCode);

      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
  }

  Timer _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          //  Get.back();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }


  @override
  void dispose() {
    sendThisNumber = "";
    textFieldEnable = true;
    if(_timer != null)_timer.cancel();
    super.dispose();
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
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey, size: 30,),
            onPressed: (){
              Get.back();
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Colors.grey.shade300),
            ),
          ),
          child: TextButton(
            onPressed: (){
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text("Back to Login", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: color1,
                  fontSize: 16
              ),),
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: globalKey,
              child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(23),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.black87, width: 2)
                        ),
                        child: LineIcon.lock(size: 60,)),
                    SizedBox(height: 15),
                    Text('Trouble with logging in?', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Text("Enter your email address. We'll send you a code. Verify the code and reset your password.", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400
                      ), textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 35),
                    TextFormField(
                      style: TextStyle(
                          color: textFieldEnable ? Colors.black87 : Colors.grey[500]
                      ),
                      enabled: textFieldEnable,
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => email = input,
                      validator: (input) => !input.contains('@')
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
                            borderSide: BorderSide(color: Colors.grey[600]),
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

                    AnimatedContainer(
                      height: textFieldEnable ? 0.0 : 55.0,
                      alignment: textFieldEnable ? Alignment.center : AlignmentDirectional.center,
                      duration: Duration(milliseconds: 1400),
                      curve: Curves.ease,
                      child: textFieldEnable ? Container() :
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          onChanged: (value) async{
                            print(value);

                            if(value == sendThisNumber.toString()) {
                              setState(() {
                                trueCode = true;
                              });
                              await Future.delayed(Duration(milliseconds: 700)).then((value) {
                                Get.to(ResetPasswordPage(userEmail: controllerEmail.text,));
                              });
                            }
                            else{
                              setState(() {
                                trueCode = false;
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Enter the code sent',
                              suffixIcon: trueCode ? Icon(Icons.check, color: Color(0xFF33A197),) : Container(width: 1,),
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]
                              )
                          ),
                        ),
                      ),
                    ),
                    textFieldEnable ? Container() :
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "$_start",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    textFieldEnable ?
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Next', style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),),
                        ),
                        color: color1,
                        onPressed: () async{
                          if(validateAndSave()) {
                            setState(() {
                              loading = false;
                            });
                            checkUserEmail();
                          }
                        },
                      ),
                    ) : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave(){
    final form = globalKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  sendEmailToUser(userEmail) async{
    String username = 'your-gmail-address';
    String password = 'your-gmail-app-password';

    final smtpServer = gmail(username, password);


    print(userEmail);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(controllerEmail.text)
      ..subject = '🔒 App Shop Password Reset ${DateTime.now()}'
      ..html = "<h2>Password Reset Code</h2>\n<p>Please use this code to reset the password.</p>\n<p>Here is your code: ${userEmail}</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      setState(() {
        textFieldEnable = false;
        loading = true;
      });
      startTimer();
      await Future.delayed(Duration(milliseconds: 1400)).then((value) {
        snackBarSuccessful("Check Your Mailbox", "We sent you a verification code");
      });
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}



