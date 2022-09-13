import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/widget_checkpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class CheckOutBasePage extends StatefulWidget {
  const CheckOutBasePage({Key? key}) : super(key: key);

  @override
  CheckOutBasePageState createState() => CheckOutBasePageState();
}

class CheckOutBasePageState<T extends CheckOutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Checkoutpage');
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child){
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.grey[100],
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: [
                      "Shipping",
                      'Payment',
                      'Order'
                    ],
                    checkPointFilledColor: Colors.green,
                  ),
                  Divider(color: Colors.grey),
                  pageUI()
                ],
              ),
            ),
            inAsyncCall: loaderModel.isApiCallProgress,
            opacity: 0.3,
          ),
        );
      }
    );
  }
   _buildAppBar(){
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0.3,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: showBackButton,
      iconTheme: IconThemeData(
        color: Colors.black87
      ),
      title: Text('Checkout', style: TextStyle(
        color: Colors.black87
      ),),
    );
  }


  Widget pageUI(){
    return null!;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
