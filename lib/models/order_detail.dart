import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/models/order.dart';

class OrderDetailModel {
  int? orderId;
  String? orderNumber;
  String? paymentMethod;
  String? orderStatus;
  DateTime? orderDate;
  Shipping? shipping;
  List<LineItems>? lineItems;
  double? totalAmount;
  double? shippingTotal;
  double? itemTotalAmount;

  OrderDetailModel({
    this.shipping,
    this.orderNumber,
    this.orderId,
    this.lineItems,
    this.paymentMethod,
    this.orderDate,
    this.totalAmount,
    this.itemTotalAmount,
    this.orderStatus,
    this.shippingTotal,
});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    paymentMethod = json['payment_method_title'];
    orderStatus = json['status'];
    orderDate = DateTime.parse(json['date_created']);
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;

    if(json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });

      itemTotalAmount = lineItems != null ?
          lineItems!.map<double>((m) => m.totalAmount!).reduce((a, b) => a + b) : 0;
    }
    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;
  String? productName;
  double? totalAmount;

  LineItems({this.quantity, this.productId, this.variationId, this.totalAmount, this.productName});


  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    totalAmount = double.parse(json['total']);
  }
}