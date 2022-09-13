import 'package:appshop/pages/bottom_bar_page.dart';
import 'package:appshop/pages/checkout_base.dart';
import 'package:appshop/pages/home_page.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderSuccessWidget extends CheckOutBasePage {
  const OrderSuccessWidget({Key? key}) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends CheckOutBasePageState<OrderSuccessWidget> {

  @override
  void initState() {
    this.currentPage = 2;
    this.showBackButton = false;

    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOrder();
    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, orderModel, child) {
        if (orderModel.isOrderCreated){
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                              colors: [
                               color1,
                               color2,
                           ]
                          )
                        ),
                        child: Icon(Icons.check,
                        color: Colors.white,
                         size: 60,),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Opacity(
                    opacity: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Your order has been successfully submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.w500
                      )),
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("You can check your order from the 'My Orders' section on your profile page.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: FlatButton(
                        onPressed: () async{
                          Get.offAll(BottomBarPage());
                        },
                        child: Text("Done", style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                        ),),
                        color: color1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return circularProgress();
      }
    );
  }
}
