import 'package:appshop/models/customer_detail_model.dart';

// create class ( Order )
class OrderModel {
  int? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  List<LineItems>? lineItems;

  int? orderId;
  String? orderNumber;
  String? status;
  DateTime? orderDate;
  Shipping? shipping;


  OrderModel({
    this.shipping,
    this.paymentMethod,
    this.status,
    this.customerId,
    this.lineItems,
    this.orderDate,
    this.orderId,
    this.orderNumber,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data["customer_id"] = customerId;
    data["payment_method"] = paymentMethod;
    data["payment_method_title"] = paymentMethodTitle;
    data["set_paid"] = setPaid;
    data["transaction_id"] = transactionId;
    data["shipping"] = shipping!.toJson();

    if(lineItems != null){
      data['line_items'] = lineItems!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class LineItems {
  int? productId;
  int? quantity;
  int? variationId;

  LineItems({this.quantity, this.productId, this.variationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data["product_id"] = this.productId;
    data["quantity"] = this.quantity;

    if(this.variationId != null){
      data['variation_id'] = this.variationId;
    }

    return data;
  }
}