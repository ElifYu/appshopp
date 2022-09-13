import 'package:appshop/api_service.dart';
import 'package:appshop/models/cart_request_model.dart';
import 'package:appshop/models/cart_response_model.dart';
import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:flutter/material.dart';



class CartProvider with ChangeNotifier{
  APIService? _apiService;
  List<CartItem>? _cartItems;

  CustomerDetailModel? _customerDetailModel;

  OrderModel? _orderModel;
  bool _isOrderCreated = false;
  List<CartItem>? get cartItems => _cartItems;
  double get totalRecords => _cartItems!.length.toDouble();
  double get totalAmount => _cartItems != null ? _cartItems!.map<double>((e) => e.lineSubtotal!.toDouble()).reduce((value, element) => value + element) : 0;
  CustomerDetailModel get customerDetailModel => _customerDetailModel!;

  OrderModel get orderModel => _orderModel!;

  bool get isOrderCreated => _isOrderCreated;

  CartProvider(){
    _apiService = APIService();
    _cartItems = <CartItem>[];
  }

  void resetStreams() {
    _apiService = APIService();
    _cartItems = <CartItem>[];
  }



  void addToCart(
      CartProducts products,
      Function onCallback
      ) async {
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];
    requestModel.addNewCart = "Add New Cart";

    if(_cartItems == null) {
      await fetchCartItem();
    }

    _cartItems!.forEach((element) {

      requestModel.products!.add(CartProducts(
          productId: element.productId,
          quantity: element.qty,
        variationId: element.variationId
      ));
    });


    var isProductExist = requestModel.products!.firstWhere((prd) => prd.productId == products.productId && prd.variationId == products.variationId,
        orElse: () => products);

    if(isProductExist != null){
      requestModel.products!.remove(isProductExist);
    }
    requestModel.products!.add(products);

    await _apiService!.addToCart(requestModel, 'Add New Cart').then((cartResponseModel) {
      if(cartResponseModel.data != null){
        _cartItems = [];
        _cartItems!.addAll(cartResponseModel.data!);
        cartResponseModel.status == true ? snackBarSuccessful('Product Added', "Product added to your cart") :
        print("");

      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartItem() async{
    if(_cartItems == null) resetStreams();

    await _apiService!.getCartItems().then((cartResponseModel) {
      if(cartResponseModel != null) {
        _cartItems!.addAll(cartResponseModel.data!);
      }
      notifyListeners();
    });
  }

  void updateQty(int productId, int qty, {int variationId = 0}){
    var isProductExist = _cartItems!.firstWhere((prd) => prd.productId == productId && prd.variationId == variationId, orElse: () => null!);

    if(isProductExist != null){
      isProductExist.qty = qty;
    }
    notifyListeners();
  }
  void updateCart(Function onCallBack) async{
    CartRequestModel requestModel = CartRequestModel();
    requestModel.products = <CartProducts>[];

    if(_cartItems == null) resetStreams();

    _cartItems!.forEach((element) {
      requestModel.products!.add(
          CartProducts(
              productId: element.productId,
              quantity: element.qty,
              variationId: element.variationId
          )
      );
    });

    await _apiService!.addToCart(requestModel, '').then((cartResponseModel) {
      if(cartResponseModel.data != null){
        _cartItems = [];
        _cartItems!.addAll(cartResponseModel.data!);
      }
      onCallBack(cartResponseModel);
      notifyListeners();
    });
  }

  void removeItem(int productId) {
    var isProductExist = _cartItems!.firstWhere((prd) => prd.productId == productId, orElse: () => null!);

    if(isProductExist != null){
      _cartItems!.remove(isProductExist);
    }
    notifyListeners();
  }

  fetchShippingDetails() async {
    if(_customerDetailModel == null){
      _customerDetailModel = CustomerDetailModel();
    }
    _customerDetailModel = await _apiService!.customerDetails();
    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    this._orderModel = orderModel;
    notifyListeners();
  }

  void createOrder() async{
    if(_orderModel!.shipping == null){
      _orderModel!.shipping = Shipping();
    }
    if(this.customerDetailModel.shipping != null){
      _orderModel!.shipping = this.customerDetailModel.shipping;
    }

    if(orderModel.lineItems == null){
      _orderModel!.lineItems = <LineItems>[];
    }

    _cartItems!.forEach((v) {
      _orderModel!.lineItems!.add(
          LineItems(
              productId: v.productId,
              quantity: v.qty,
              variationId: v.variationId
          )
      );
    });

    await _apiService!.createOrder(orderModel).then((value) {
      if(value) {
        _isOrderCreated = true;
        notifyListeners();
      }
    });
  }
}
