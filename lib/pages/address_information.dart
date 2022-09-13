import 'dart:async';
import 'dart:convert';
import 'package:appshop/config.dart';
import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class AddressInformation extends StatefulWidget {
  String? note;
  AddressInformation({Key? key, this.note}) : super(key: key);

  @override
  _AddressInformationState createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation> {

  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerAddressTitle = TextEditingController();

  updateUserInf(userName, userFirstName, userLastName) async{
    await storage.write(key: "userName", value: userName);
    await storage.write(key: "userFirstName", value: userFirstName);
    await storage.write(key: "userLastName", value: userLastName);
    read().then((value) => setState((){}));
  }

  bool saveLoading = false;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  changeUserName() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('PUT', Uri.parse(Config.url + 'customers/${Config.userID}?consumer_key=${Config.key}&consumer_secret=${Config.secret}'));
    request.body = json.encode({
      "first_name": controllerFirstName.text,
      "last_name": controllerLastName.text,
      "billing": {
        "first_name": controllerFirstName.text,
        "last_name": controllerLastName.text,
        "company": "",
        "address_1": controllerAddress.text,
        "address_2": controllerAddressTitle.text,
        "city": controllerCity.text,
        "postcode": "",
        "country": controllerCountry.text,
        "state": controllerState.text,
        "email": userEmail,
        "phone": controllerPhoneNumber.text,
      },
      "shipping": {
        "first_name": controllerFirstName.text,
        "last_name": controllerLastName.text,
        "company": "",
        "address_1": controllerAddress.text,
        "address_2": controllerAddressTitle.text,
        "city": controllerCity.text,
        "postcode": "",
        "country": controllerCountry.text,
        "state": controllerState.text,
        "email": userEmail,
        "phone": controllerPhoneNumber.text,
      },
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
    // TODO: implement initState
    super.initState();
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }


  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: saveLoading,
      opacity: 0.3,
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
          title:  Text("Edit Address", style: TextStyle(
              color: Colors.black87,
              fontSize: 17
          ),),
        ),
        body: Consumer<CartProvider>(
            builder: (context, customerModel, child){
              if(customerModel.customerDetailModel.id != null) {
                return _formUI(customerModel.customerDetailModel);
              }
              return circularProgress();
            }
        )),
    );
  }

  _formUI(CustomerDetailModel model){
    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.note == "0" ? Container(
              color: color3,
              child: ListTile(
                leading: LineIcon.infoCircle(color: color1,),
                minLeadingWidth: 0,
                title: Text("Please fill in all the fields and proceed with the payment",
                  style: TextStyle(
                      fontSize: 16,
                      color: color1,
                      fontWeight: FontWeight.w600
                  ),),
              )
            ) : Container(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Contact Information', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    top: BorderSide(color: Colors.grey.shade300),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5, top: 5),
                child: Column(
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
                            controller: controllerFirstName..text = model.firstName!,
                            validator: (input) => input!.isEmpty
                                ? "Please enter your first name" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your first name',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
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
                            controller: controllerLastName..text = model.lastName!,
                            validator: (input) => input!.isEmpty
                                ? "Please enter your last name" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your last name',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text("Phone Number", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,

                          ),),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controllerPhoneNumber..text = model.billing!.phone!,
                            validator: (input) => input!.isEmpty
                                ? "Please enter your phone number" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your phone number',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Address Information', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    top: BorderSide(color: Colors.grey.shade300),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5, top: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text("Country", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,

                          ),),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controllerCountry..text = model.billing!.country!,
                            validator: (input) => input!.isEmpty
                                ? "This field is required to be filled" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your country',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text("City", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,

                          ),),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controllerCity..text = model.billing!.city!,
                            validator: (input) => input!.isEmpty
                                ? "This field is required to be filled" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your city',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text("State", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,

                          ),),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controllerState..text = model.billing!.state!,
                            validator: (input) => input!.isEmpty
                                ? "This field is required to be filled" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your state',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text("Address", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,

                            ),),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: 5,
                            controller: controllerAddress..text = model.billing!.address1!,
                            validator: (input) => input!.isEmpty
                                ? "This field is required to be filled" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your address',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(height: 0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text("Address Title", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,

                            ),),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controllerAddressTitle..text = model.billing!.address2!,
                            validator: (input) => input!.isEmpty
                                ? "This field is required to be filled" : null,
                            cursorColor: Colors.grey[800],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter your address title',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500]
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.03,
                child: FlatButton(
                  onPressed: (){
                    if(validateAndSave()){
                      read().then((value) {
                        setState(() {
                          saveLoading = true;
                          changeUserName();
                        });
                      });
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
            SizedBox(height: 30),
          ],
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
