import 'package:appshop/config.dart';
import 'package:appshop/pages/login_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:http/http.dart' as http;
class DeleteUserAccount extends StatefulWidget {
  const DeleteUserAccount({Key? key}) : super(key: key);

  @override
  _DeleteUserAccountState createState() => _DeleteUserAccountState();
}

class _DeleteUserAccountState extends State<DeleteUserAccount> {


  bool deleteLoadingRes = false;

  removeUserAccount() async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('DELETE', Uri.parse(Config.url + 'customers/${Config.userID}?consumer_key=${Config.key}&consumer_secret=${Config.secret}&force=true'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      setState(() {
        deleteLoadingRes = false;
      });
      snackBarSuccessful("Successfully Removed", "Your account has been successfully removed");
      delete();
      Get.offAll(LoginPage());
    }
    else {
      setState(() {
        deleteLoadingRes = false;
      });
      snackBarFailed(response.statusCode.toString(), "Your account couldn't be remove");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: deleteLoadingRes,
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
          title:  Text("Remove Account", style: TextStyle(
              color: Colors.black87,
              fontSize: 17
          ),),
        ),
        body: SingleChildScrollView(
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
                    SizedBox(height: 10),
                    Text("We're sorry to see you're going", style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                      fontSize: 15
                    ),),
                    SizedBox(height: 10),
                    ListTile(
                      minLeadingWidth: 0,
                      leading: Icon(Icons.circle, color: Colors.blueAccent, size: 12),
                      title: Text('You will not be able to reactivate your account.',
                        style: TextStyle(
                        fontSize: 15
                      ),),
                    ),

                    ListTile(
                      minLeadingWidth: 0,
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: Colors.blueAccent, size: 12),
                        ],
                      ),
                      title: Text('You will not be able to view your order history.',
                        style: TextStyle(
                            fontSize: 15
                        ),),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Text('Are you sure you want to remove your account? This cannot be undone.',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15
                ),),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        deleteLoadingRes = true;
                      });
                      read().then((value) {
                        setState(() {
                          Config.userID = jwt;
                          print(Config.userID);
                          removeUserAccount();
                        });
                      });
                    },
                    child: Text("Yes, delete my account", style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
            ],
          ),
        ),
      ),
    );
  }
}
