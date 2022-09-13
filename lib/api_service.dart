import 'dart:convert';
import 'dart:io';
import 'package:appshop/models/get_comments.dart';
import 'package:appshop/models/variable_product.dart';
import 'package:appshop/config.dart';
import 'package:appshop/models/cart_request_model.dart';
import 'package:appshop/models/cart_response_model.dart';
import 'package:appshop/models/category.dart';
import 'package:appshop/models/customer.dart';
import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/models/login_model.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/models/order_detail.dart';
import 'package:appshop/models/product.dart';
import 'package:dio/dio.dart';



class APIService{
  Future<bool> createCustomer(CustomerModel model) async{
    var authToken = base64.encode(utf8.encode(Config.key + ":" + Config.secret),
    );
    bool ret = false;

    try{
      var response = await Dio().post(
        Config.url + Config.customerURl,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader : 'Basic $authToken',
            HttpHeaders.contentTypeHeader : "application/json"
          }
        )
      );
      print(response.data);
      if(response.statusCode == 201){
        ret = true;
      }
    }on DioError catch(e){
      if(e.response?.statusCode == 404){
        print(e.response!.statusCode);
        ret = false;
      }
      {
        print(e.message);
        ret = false;
      }
    }
    return ret;
  }

  Future<LoginResponseModel> loginCustomer(String username, String password) async{
    LoginResponseModel model = LoginResponseModel();

    try{
      var response = await Dio().post(
        Config.tokenURl,
        data: {
          "username": username,
          "password": password
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
        )
      );
      print(response.data);
      if(response.statusCode == 200){
        model = LoginResponseModel.fromJson(response.data);
      }
      if(response.statusCode == 403) {
        print(response.data);
      }
    } on DioError catch (e){
      print(e.message);
    }
    return model;
  }


  Future<CartResponseModel> addToCart(CartRequestModel model, addNewCart) async{
    model.userId = int.parse(Config.userID);
    print(model.toJson().toString());


    late CartResponseModel responseModel;
    try{
      var response = await Dio().post(
          Config.url + Config.addToCartURL,
          data: model.toJson(),
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );
      print(response.data);
      if(response.statusCode == 200){
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        print(e.response!.statusCode);
        print(e.message);
        print(e.response);
      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
    return responseModel;
  }


  Future<CartResponseModel> getCartItems() async{

    late CartResponseModel responseModel;

    try{
      var response = await Dio().get(
          Config.url + Config.cartURL + "?user_id=${Config.userID}&consumer_key=${Config.key}&consumer_secret=${Config.secret}",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );

      print(response.data);
      if(response.statusCode == 200){
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        print(e.response!.statusCode);

      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
    return responseModel;
  }


  Future<List<Category>> getCategories() async{
    List<Category> data = <Category>[];

    try{
      String url = Config.url + Config.categoriesURl
      + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&per_page=8";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }
        )
      );

      if(response.statusCode == 200){
        data = (response.data as List).map((i) => Category.fromJson(i)).toList();
      }

    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<Product>> getProducts({
    int? pageNumber,
    int? pageSize,
    String? strSearch,
    String? tagName,
    String? categoryId,
    List<int>? productsIDs,
    String? sortBy,
    String sortOrder = "asc"
  }) async{
    List<Product> data = <Product>[];

    try{

      String parameter = "";

      if(strSearch != null){
        parameter += "&search=$strSearch";
      }

       if(pageSize != null){
        parameter += "&per_page=$pageSize";
      }
       if(pageNumber != null){
        parameter += "&page=$pageNumber";
      }

       if(tagName != null){
        parameter += "&tag=$tagName";
      }

       if(categoryId != null){
        parameter += "&category=$categoryId";
      }
       if(sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      if(productsIDs != null) {
        parameter += "&include=${productsIDs.join(",").toString()}";
      }
      if(sortOrder != null) {
        parameter += "&order=$sortOrder";
      }

      print(parameter);
      String url = Config.url + Config.productURl + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}"
          "${parameter.toString()}&fbclid=IwAR0LsSJhGNvDW3K4kJ4tOzYJUOu2wnYJswtxfJJoMZJy35wyrd3awKwPv9Y";

      var response = await Dio().get(
          url,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        data = (response.data as List).map((i) => Product.fromJson(i)).toList();
      }

    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }


  Future<CustomerDetailModel> customerDetails() async{

    late CustomerDetailModel responseModel;

    try{
      var response = await Dio().get(
          Config.url + Config.customerURl + "/${Config.userID}?consumer_key=${Config.key}&consumer_secret=${Config.secret}",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );

      if(response.statusCode == 200){
        responseModel = CustomerDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        print(e.response!.statusCode);

      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
    return responseModel;
  }

  Future<bool> createOrder(OrderModel model) async{

    model.customerId = int.parse(Config.userID);

    bool isOrderCreated = false;

    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.secret)
    );

    try{
      var response = await Dio().post(
          Config.url + Config.orderURL,
          data: model.toJson(),
          options: Options(
              headers: {
                HttpHeaders.authorizationHeader : "Basic $authToken",
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );

      if(response.statusCode == 201){
        isOrderCreated = true;
        print(model.toJson());
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        print(e.response!.statusCode);

      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrders() async{

    List<OrderModel> data = <OrderModel>[];
    print(Config.userID);

    try{
      var response = await Dio().get(
          Config.url + Config.orderURL + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&customer=${Config.userID}",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );

      if(response.statusCode == 200){
      data = (response.data as List).map((i) =>
        OrderModel.fromJson(i)
      ).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<OrderDetailModel> getOrderDetails(int orderId) async{

    OrderDetailModel responseModel = OrderDetailModel();

    try{
      var response = await Dio().get(
          Config.url + Config.orderURL + "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.secret}",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );

      if(response.statusCode == 200){
       responseModel = OrderDetailModel.fromJson(response.data);
       print(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }


  Future<List<VariableProduct>> getVariableProducts(productId) async{


    List<VariableProduct>? responseModel;
    try{
      var response = await Dio().get(
          Config.url + Config.productURl + '/${productId.toString()}/${Config.variableProductsURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader : "application/json",
              }
          )
      );
      print(response.data);
      if(response.statusCode == 200){
        responseModel = (response.data as List).map((e) => VariableProduct.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == 404){
        print(e.response!.statusCode);
        print(e.message);
        print(e.response);
      }
      else{
        print(e.message);
        print(e.requestOptions);
      }
    }
    return responseModel!;
  }


  Future<List<GetComments>> getComments({
    int? pageNumber,
    int? pageSize,
    String? productId,
  }) async{
    List<GetComments> data = <GetComments>[];

    try{

      String parameter = "";

      if(pageSize != null){
        parameter += "&per_page=$pageSize";
      }
      if(pageNumber != null){
        parameter += "&page=$pageNumber";
      }


      print(parameter);
      String url = Config.url + Config.reviewsURL + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}&product=${productId.toString()}${parameter.toString()}";

      var response = await Dio().get(
          url,
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }
          )
      );
      if(response.statusCode == 200){
        data = (response.data as List).map((i) => GetComments.fromJson(i)).toList();
      }

    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }


}