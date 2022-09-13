import 'package:appshop/pages/address_information.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/change_name_profile.dart';
import 'package:appshop/pages/login_page.dart';
import 'package:appshop/pages/orders_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:appshop/utils/utils.dart';
import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class WidgetProfilePage extends StatefulWidget {
  const WidgetProfilePage({Key? key}) : super(key: key);

  @override
  _WidgetProfilePageState createState() => _WidgetProfilePageState();
}

class _WidgetProfilePageState extends State<WidgetProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read().then((value) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return jwt == null ? UserNotSignIn() :
    Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Profile", style: TextStyle(
            color: Colors.black87,
            fontSize: 17
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                      name: userName,
                      placeholderColors: [
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0) //...
                      ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(userName, style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                    ), textAlign: TextAlign.center,),
                  )
                ],
              )
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: ListTile(
                onTap: (){
                  Get.to(OrdersPage());
                },
                minLeadingWidth: 0,
                leading: LineIcon.shoppingBag(color: Colors.black87,  size: 30),
                title: Text('My Orders'),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('Check my orders', style: TextStyle(
                    color: Colors.black45
                  ),),
                ),
                trailing: LineIcon.angleRight(color: Colors.black45,  size: 20)
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: ListTile(
                onTap: (){
                  Get.to(AddressInformation());
                },
                trailing: LineIcon.angleRight(color: Colors.black45,  size: 20),
                minLeadingWidth: 0,
                leading: LineIcon.mapMarker(color: Colors.black87,  size: 30),
                title: Text('Address Information'),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text('Edit your address information', style: TextStyle(
                      color: Colors.black45
                  ),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: ListTile(
                onTap: (){
                  Get.to(WidgetChangeName())!.then((value) {
                    setState(() {

                    });
                  });
                },
                trailing: LineIcon.angleRight(color: Colors.black45,  size: 20),
                minLeadingWidth: 0,
                leading: LineIcon.pen(color: Colors.black87,  size: 30),
                title: Text("User Information"),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text('Change your user information', style: TextStyle(
                      color: Colors.black45
                  ),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: ListTile(
                onTap: (){
                  Utils.showMessage(context, 'Confirmation', 'Are you sure you want to delete all history?',
                      'YES', () async{

                        Get.back();
                        snackBarSuccessful("Successfully Cleared", "Your history has been successfully cleared");
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        setState(() {
                          pref.remove('saveSearcHistory');
                        });
                      }, buttonText2: 'NO',
                      isConfirmationDialog: true,
                      onPressed2: (){
                        Get.back();
                      });
                },
                trailing: LineIcon.angleRight(color: Colors.black45,  size: 20),
                minLeadingWidth: 0,
                leading: LineIcon.broom(color: Colors.black87,  size: 30,),
                title: Text('Clear History'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text('Clear all history', style: TextStyle(
                      color: Colors.black45
                  ),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: ListTile(
                onTap: (){
                  Utils.showMessage(context, 'Sign Out', 'Do you really want to sign out from your account?',
                      'SIGN OUT', () async{
                          delete();
                          Get.offAll(LoginPage());
                      }, buttonText2: 'CANCEL',
                      isConfirmationDialog: true,
                      onPressed2: (){
                        Navigator.of(context).pop();
                      });
                },
                trailing: LineIcon.angleRight(color: Colors.black45,  size: 20),
                minLeadingWidth: 0,
                leading: LineIcon.alternateSignOut(color: Colors.black87, size: 30,),
                title: Text('Sign out'),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

