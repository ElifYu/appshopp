import 'package:appshop/api_service.dart';
import 'package:appshop/models/customer.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/form_helper.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:appshop/utils/validator_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  APIService? apiService;
  CustomerModel? model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool hidePassword =  true;
  bool isApiCallProcess = false;

  bool checkedValue = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = APIService();
    model =  CustomerModel();
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: isApiCallProcess,
      valueColor: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey, size: 30,),
            onPressed: (){
              Get.back();
            },
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Do you have an account? ",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 16
                      ),
                      children: [
                        TextSpan(
                          text: ' Sign In',
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
        body: Form(
            key: globalKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("Create Account ✨", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.black87
                    ),),
                    SizedBox(height: 10),
                    Text("Enjoy shopping with App Shop", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black38
                    ),),
                    SizedBox(height: MediaQuery.of(context).size.height / 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("First Name", style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  fontSize: 16
                              ),),
                              SizedBox(height: 10),
                              TextFormField(
                                validator: (input) => input!.isEmpty
                                    ? "Please enter your first name" : null,
                                onChanged: (value) {
                                  setState(() {
                                    this.model!.firstName = value;
                                  });
                                },
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
                                    hintText: 'First name',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[500]
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Last Name", style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  fontSize: 16
                              ),),
                              SizedBox(height: 10),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    this.model!.lastName = value;
                                  });
                                },
                                validator: (input) => input!.isEmpty
                                    ? "Please enter your last name" : null,
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
                                    hintText: 'Last name',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[500]
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text("Email Address", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 16
                    ),),
                    SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          this.model!.email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
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

                    SizedBox(height: 30),

                    Text("Password", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 16
                    ),),
                    SizedBox(height: 10),
                    TextFormField(
                      cursorColor: Colors.grey[800],
                      onChanged: (value) {
                        setState(() {
                          this.model!.password = value;
                        });
                      },
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
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text("I agree to the terms & conditions"),
                      value: checkedValue,
                      activeColor: Colors.blueAccent,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    checkedValue ?
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Sign Up', style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),),
                        ),
                        color: color1,
                        onPressed: (){
                          if(validateAndSave()){
                            print(model!.toJson());
                            setState(() {
                              isApiCallProcess = true;
                            });
                            apiService?.createCustomer(model!).then((ret) {
                              setState(() {
                                isApiCallProcess = false;
                              });
                              print(ret);
                              if(ret){
                                snackBarSuccessful('Account Successfully Created', "Your account has been created, you can sign in");
                                Get.back();
                              }
                              else{
                                snackBarFailed('Oops!', "This email already registered");
                              }
                            });
                          }
                        },
                      ),
                    ) :
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Sign Up', style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),),
                        ),
                        color: Colors.grey,
                        onPressed: (){


                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget _formUI(){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////// Name Input //////////////////
                FormHelper.fieldLabel('First Name'),
                FormHelper.textInput(
                  context,
                  model!.firstName.toString(),
                    (value) => {
                    this.model!.firstName = value
                    },
                  onValidate: (value){
                    if (value.toString().isEmpty){
                      return "Please Enter First Name";
                    }
                    return null;
                  },
                  suffixIcon: Text(''),
                  prefixIcon: Text('')
                ),

                ////////////////////// Last Name Input //////////////////
                FormHelper.fieldLabel('Last Name'),
                FormHelper.textInput(
                  context,
                  model!.lastName.toString(),
                    (value) => {
                    this.model!.lastName = value
                    },
                    onValidate: (value){
                      return null;
                    },
                    suffixIcon: Text(''),
                    prefixIcon: Text('')
                ),
                ////////////////////// Email Input //////////////////
                FormHelper.fieldLabel('Email'),
                FormHelper.textInput(
                    context,
                    model!.email.toString(),
                        (value) => {
                      this.model!.email = value
                    },
                    onValidate: (value){
                      if (value.toString().isEmpty){
                        return "Please Enter Email";
                      }
                      if (value.toString().isNotEmpty && !value.toString().isValidEmail()){
                        return "Please Enter Valid Email";
                      }
                      return null;
                    },
                    suffixIcon: Text(''),
                    prefixIcon: Text('')
                ),

                ////////////////////// Password Input //////////////////

                FormHelper.fieldLabel('Password'),
                FormHelper.textInput(
                    context,
                    model!.password.toString(),
                        (value) => {
                      this.model!.password = value
                    },
                    onValidate: (value){
                      if (value.toString().isEmpty){
                        return "Please Enter Password";
                      }
                      return null;
                    },
                    obscureText: hidePassword,
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility
                      ),
                    ),
                    prefixIcon: Text('')
                ),

                SizedBox(height: 20),
                Center(
                  child: FormHelper.saveButton(
                    "Register", (){
                      if(validateAndSave()){
                        print(model!.toJson());
                        setState(() {
                          isApiCallProcess = true;
                        });
                      apiService?.createCustomer(model!).then((ret) {
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if(ret){
                          FormHelper.showMessage(
                            context,
                            "WooCommerce App",
                            "Register SuccessFull",
                            'Ok', () {
                              Navigator.of(context).pop();
                            }
                          );
                        }
                        else{
                          FormHelper.showMessage(
                            context,
                            "WooCommerce App",
                            "Email Already Registred",
                            "Ok", (){
                            Navigator.of(context).pop();
                            }
                          );
                        }
                      });
                      }
                  }
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
