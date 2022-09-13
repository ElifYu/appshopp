import 'dart:convert';

import 'package:appshop/config.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/provider/order_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/widgets/widget_order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  List<OrderModel>? orders;

  @override
  void initState() {
    super.initState();
    read().then((value) {
      setState(() {
        print(jwt);
        var orderProvider = Provider.of<OrderProvider>(context, listen: false);
        orderProvider.fetchOrders();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title:  Text("My Orders", style: TextStyle(
            color: Colors.black87,
            fontSize: 17
        ),),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderModel, child){
          if(orderModel.allOrders != null && orderModel.allOrders!.length > 0) {
            return _listView(context, orderModel.allOrders!);
          }
          return circularProgress();
        }
      ),
    );
  }

  Widget _listView(BuildContext context, List<OrderModel> order){
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300)
              ),
              child:  WidgetOrderItem(
                orderModel: order[index],
              ),
            );
          }
        )
      ],
    );
  }
}
