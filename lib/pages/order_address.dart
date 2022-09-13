import 'dart:convert';
import 'dart:io';
import 'package:appshop/config.dart';
import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/pages/checkout_base.dart';
import 'package:appshop/pages/order_address.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/widgets/widget_order_success.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';


class PaymentMethodsWidget extends CheckOutBasePage {
  var moneyAmount;
  CustomerDetailModel? model;
  PaymentMethodsWidget({Key? key, this.moneyAmount, this.model}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends CheckOutBasePageState<PaymentMethodsWidget> {

  Map<String, dynamic>? paymentIntentData;

  var listProducts;

  @override
  void initState() {
    super.initState();
    read().then((value) => setState(() {}));
    currentPage = 1;
    makePayment(amount: widget.moneyAmount.toString().replaceAll('.', ''), currency: 'USD');
  }
  @override
  Widget pageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Text('Total:', style: TextStyle(
                fontSize: 17
              ),),
              Spacer(),
              Text('\$' + widget.moneyAmount.toString(), style: TextStyle(
                  fontSize: 20
              ),),
            ],
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.03,
            child: FlatButton(
              onPressed: () async{
                print(widget.moneyAmount.toString().replaceAll('.', ''));
                makePayment(amount: widget.moneyAmount.toString().replaceAll('.', ''), currency: 'USD');
              },
              child: Text("Checkout", style: TextStyle(
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
      ],
    );
  }


  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
       await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              applePay: true,
              googlePay: true,
              testEnv: true,
              billingDetails: BillingDetails(
                  email: userEmail,
                  phone:     widget.model!.billing!.phone ?? "",
                  name:      widget.model!.firstName,
                  address: Address(
                    city:    widget.model!.billing!.city,
                    country: widget.model!.billing!.country,
                    line1:   widget.model!.billing!.address1,
                    line2:   widget.model!.billing!.address2,
                    state:   widget.model!.billing!.state,
                    postalCode: ' ',
                  )
              ),
              merchantCountryCode: 'US',
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            ));
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
     print("Payment Payment Successful");
     var orderProvider = Provider.of<CartProvider>(context, listen: false);
     OrderModel orderModel = OrderModel();
     orderModel.paymentMethod = 'Stripe';
     orderModel.paymentMethodTitle = 'Stripe';
     orderModel.setPaid = true;
     orderModel.transactionId = paymentIntentData!['customer'];

     orderProvider.processOrder(orderModel);

     Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccessWidget()),
     );

    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    var bearer = "your-stripe-secret-key";
    try {
      var body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        "description": '${
                widget.model!.firstName! + ' ' +
                widget.model!.billing!.lastName! + ' ' + widget.model!.billing!.phone! + ' ' +
                widget.model!.billing!.country! + ' ' + widget.model!.billing!.city! + ' ' +
                widget.model!.billing!.state! +  widget.model!.billing!.address1! + ' ' +
                widget.model!.billing!.address2!
        }'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $bearer',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount));
    return a.toString();
  }
}
