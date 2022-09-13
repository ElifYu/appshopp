import 'package:appshop/models/order.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/widgets/widget_order_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WidgetOrderItem extends StatelessWidget {
  OrderModel? orderModel;
  WidgetOrderItem({Key? key, this.orderModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderStatus(this.orderModel!.status!),
            Divider(color: Colors.grey,),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),),
                Text(this.orderModel!.orderNumber.toString(), style: TextStyle(
                    fontSize: 14
                ),),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Date', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),),
                Text(this.orderModel!.orderDate.toString(), style: TextStyle(
                    fontSize: 14
                ),),

              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  color: color3,
                  onPressed: (){
                    Get.to(OrderDetailPage(orderID: this.orderModel!.orderId));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Text('Order Details', style: TextStyle(
                          color: color1
                      ),),
                      Icon(Icons.chevron_right, color: color1)
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: [
        iconWidget,
        SizedBox(width: 5),
        textWidget
      ],
    );
  }

  Widget flatButton(Widget iconText, Function onPressed) {
    return FlatButton(
      child: iconText,
      onPressed: (){onPressed();},
      padding: EdgeInsets.all(5),
      color: Colors.green,
      shape: StadiumBorder(),
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if(status == "pending" || status == "processing" || status == "on-hold"){
      icon = Icon(Icons.timer, color: Colors.orange);
      color = Colors.orange;
    }
    else if(status == 'completed') {
      icon = Icon(Icons.check, color: Colors.green);
      color = Colors.green;
    }
    else if(status == 'cancelled' || status == 'refunded' ||
        status == "failed") {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    }
    else{
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    }

    return iconText(icon, Text("Order $status", style: TextStyle(
        fontSize: 15,
        color: color,
        fontWeight: FontWeight.bold
    ),));
  }
}

