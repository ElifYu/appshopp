import 'package:appshop/api_service.dart';
import 'package:appshop/models/order_detail.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/widget_checkpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

class OrderDetailPage extends StatefulWidget {
  int? orderID;
  OrderDetailPage({Key? key, this.orderID}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  APIService? apiService;

  @override
  void initState() {
    super.initState();
    apiService = APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title:  Text("My Order Detail", style: TextStyle(
            color: Colors.black87,
            fontSize: 17
        ),),
      ),
      body: FutureBuilder(
        future: apiService!.getOrderDetails(this.widget.orderID!),
        builder: (BuildContext context, AsyncSnapshot<OrderDetailModel> orderDetailModel){
          if(orderDetailModel.hasData) {
            return orderDetailUI(orderDetailModel.data!);
          }
          return circularProgress();
        },
      ),
    );
  }

  Widget orderDetailUI(OrderDetailModel model) {

    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('#${model.orderId.toString()}'),
          SizedBox(height: 10),
          Text(model.orderDate.toString()),
          SizedBox(height: 20),
          Text('Deliver To', style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: color1
          ),),
          SizedBox(height: 8),
          Text(model.shipping!.address1.toString(), style: TextStyle(
            fontSize: 15
          ),),
          SizedBox(height: 4),
          Text(model.shipping!.address2.toString(), style: TextStyle(
              fontSize: 15
          ),),
          SizedBox(height: 4),
          Text('${model.shipping!.city.toString()} ${model.shipping!.state.toString()}', style: TextStyle(
              fontSize: 15
          ),),


          SizedBox(height: 20),
          Text('Payment Method', style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: color1
          ),),
          SizedBox(height: 8),
          Text(model.paymentMethod.toString(), style: TextStyle(
              fontSize: 15
          ),),
          SizedBox(height: 15),
          Divider(color: Colors.grey),
          SizedBox(height: 15),
          CheckPoints(
            checkedTill: model.orderStatus == 'processing' ? 0 :  model.orderStatus == 'completed' ? 2 : 1,
            checkPoints: ["Processing", 'Shipping', 'Delivered'],
            checkPointFilledColor: color1,
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          _listOrderItems(model),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          _itemTotal("Paid", "${model.totalAmount}", textStyle: TextStyle(
            fontSize: 16,
            color: color1,
            fontWeight: FontWeight.w600
          )),
          SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _listOrderItems(OrderDetailModel model){
    return ListView.builder(
      itemCount: model.lineItems!.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index){
        return _productItems(model.lineItems![index]);
      }

    );
  }

  Widget _productItems(LineItems product){
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: (){},
      title: Text(product.productName.toString(), style: TextStyle(
        fontSize: 16
      ),),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: Text('Qty ${product.quantity}', style: TextStyle(
          fontSize: 14
        ),),
      ),
      trailing: Text('\$${product.totalAmount}'),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle? textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: Text(label, style: textStyle,),
      trailing: Text("\$$value", style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16
      ),),
    );
  }
}


