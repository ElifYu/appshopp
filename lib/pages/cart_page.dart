import 'dart:convert';
import 'dart:io';
import 'package:appshop/config.dart';
import 'package:appshop/models/cart_response_model.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/login_page.dart';
import 'package:appshop/pages/product_details.dart';
import 'package:appshop/pages/verify_address.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:appshop/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';


class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  Map<String, dynamic>? paymentIntentData;

  refresh() async{
    await Future.delayed(Duration(milliseconds: 600)).then((value) {
      Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
      var cartProvider = Provider.of<CartProvider>(context, listen: false);

      cartProvider.updateCart((val) {
        Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);
      });
    });
  }

  var numberQty;
  bool? loading = false;
  var ind;
  bool openCartDetail = false;

  changeQty(productId, variationId, model) async {
    var authToken = base64.encode(
        utf8.encode(Config.key + ":" + Config.secret)
    );
    var headers = {
      'Authorization': 'Basic $authToken',
    };
    var request = http.Request('GET', Uri.parse(
        '${Config.url}products/${productId.toString()}/variations/${variationId
            .toString()}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var js = json.decode(await response.stream.bytesToString());
      setState(() {
        if(js['stock_quantity'] == null){
          setState(() {
            loading = false;
            numberQty = 30;
            showBottom(context, productId, model);
          });
        }
        else{
          setState(() {
            loading = false;
            numberQty = js['stock_quantity'];
            showBottom(context, productId, model);
          });
        }
      });
    }
    else {
      if(response.reasonPhrase == "Not Found"){
        getProducts(productId, model);
        print('go');
      }
      else{
        setState(() {
          loading = false;
          snackBarWarning("Oops!", "Request failed ${response.statusCode.toString()}");
        });
      }
    }
  }

  Future getProducts(productId, model) async{
    String url = Config.url + Config.productURl + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}"
        "&include=${productId.toString()}";

    var response = await Dio().get(
        url,
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }
        )
    );
    if(response.statusCode == 200){
      if(response.data[0]['stock_quantity'] != null){
        setState(() {
          loading = false;
          numberQty = response.data[0]['stock_quantity'];
          showBottom(context, productId, model);
        });
      }
      else{
        setState(() {
          loading = false;
          numberQty = 30;
          showBottom(context, productId, model);
        });
      }
    }
    else {
      setState(() {
        loading = false;
        snackBarWarning("Oops!", "Request failed ${response.statusCode.toString()}");
      });
    }
  }


  Future<List<Product>> getProductsDetail(productId) async{
    List<Product> data = <Product>[];
    try{

      String url = Config.url + Config.productURl + "?consumer_key=${Config.key}&consumer_secret=${Config.secret}"
          "&include=${productId.toString()}";

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
        setState(() {
          openCartDetail = false;
        });
        Get.to(ProductDetails(product: data[0]));
      }
      else {
        setState(() {
          openCartDetail = false;
        });
      }
    } on DioError catch (e) {
      print(e.response);
      setState(() {
        openCartDetail = false;
      });
    }
    return data;
  }


  @override
  void initState() {
    super.initState();
    read().then((value) {
      setState(() {});
    });
    if(jwt != null){
      var cartItemList = Provider.of<CartProvider>(context, listen: false);
      cartItemList.resetStreams();
      cartItemList.fetchCartItem();
    }
  }


  @override
  Widget build(BuildContext context) {
    return jwt == null ? UserNotSignIn() : Consumer<LoaderProvider>(
        builder: (context, loaderModel, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              elevation: 0.3,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Text("My Cart", style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17
              ),),
            ),
            body: ProgressHUD(
              child: ProgressHUD(
                inAsyncCall: openCartDetail,
                opacity: 0.3,
                child: RefreshIndicator(
                  color: color1,
                    backgroundColor: color3,
                    onRefresh: () => refresh(),
                    child: _cartItemsList()),
              ),
              inAsyncCall: loaderModel.isApiCallProgress,
              opacity: 0.3,
            ),
          );
        }
    );
  }
  Widget _cartItemsList(){
    return Consumer<CartProvider>(
        builder: (context, cartModel, child) {
          if(cartModel.cartItems != null && cartModel.cartItems!.length > 0){
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: cartModel.cartItems!.length,
                      itemBuilder: (context, index){
                        return Dismissible(
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
                              Utils.showMessage(context, 'Confirmation', 'Are you sure you want to delete this product from your cart?',
                                  'YES', (){
                                Navigator.of(context).pop();
                                Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
                                var cartProvider = Provider.of<CartProvider>(context, listen: false);

                                cartProvider.updateCart((val) {
                                  Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);
                                  Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
                                  Provider.of<CartProvider>(context, listen: false).removeItem(cartModel.cartItems![index].productId!);

                                  Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);

                                });
                              }, buttonText2: 'NO',
                                  isConfirmationDialog: true,
                                  onPressed2: (){
                                    Navigator.of(context).pop();
                                  });
                            }
                          },
                          key: ValueKey<CartItem>(cartModel.cartItems![index]),
                          background: slideLeftBackground(),
                          child: AbsorbPointer(
                            absorbing: loading!,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  openCartDetail = true;
                                });
                                getProductsDetail(cartModel.cartItems![index].productId);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade300,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
                                  margin: EdgeInsets.only(top: 10),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(7),
                                          child: CachedNetworkImage(
                                            imageUrl: cartModel.cartItems![index].thumbnail.toString(),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(color: Colors.white,),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                        SizedBox(width: 10),

                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${cartModel.cartItems![index].productName}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ), maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,),
                                                  SizedBox(height: 4),
                                                  Text('${cartModel.cartItems![index].attributeValue.toString()
                                                      .replaceAll('[', '')
                                                      .replaceAll(']', "")}',
                                                    style: TextStyle(
                                                        color: color1
                                                    ),),
                                                ],
                                              ),
                                              Positioned.fill(
                                                  bottom: 0.0,
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '${cartModel.cartItems![index].productSalePrice.toString()}',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                            ),),
                                                        ),
                                                        SizedBox(
                                                          child: GestureDetector(
                                                            onTap: () {

                                                              print(cartModel.cartItems![index].attribute);
                                                              if(cartModel.cartItems![index].attribute.toString().isEmpty){
                                                                setState(() {
                                                                  loading = true;
                                                                  ind = cartModel.cartItems![index].productId;
                                                                });
                                                                getProducts(cartModel.cartItems![index].productId, cartModel.cartItems![index]);
                                                              }
                                                              else{
                                                                setState(() {
                                                                  loading = true;
                                                                  ind = cartModel.cartItems![index].productId;
                                                                });
                                                                changeQty(cartModel.cartItems![index].productId, cartModel.cartItems![index].variationId, cartModel.cartItems![index]);
                                                              }

                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey[200],
                                                                  borderRadius: BorderRadius.circular(50)
                                                              ),
                                                              padding: EdgeInsets.only(
                                                                  left: 10, right: 10, top: 5, bottom: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  LineIcon.minus(size: 18,),
                                                                  SizedBox(width: 10),
                                                                  loading == true ? ind == cartModel.cartItems![index].productId ? CupertinoActivityIndicator() :
                                                                  Text(cartModel.cartItems![index].qty.toString()) : Text(cartModel.cartItems![index].qty.toString()),
                                                                  SizedBox(width: 10),
                                                                  LineIcon.plus(size: 18,),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          )
                        );
                      }
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                   color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      top: BorderSide(color: Colors.grey.shade300),
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500
                                  ),),
                                Text("\$${(cartModel.totalAmount).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16
                                ),)
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            color: color1,
                            child: Text('Checkout', style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),),
                            onPressed: () async{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyAddress(
                                  moneyAmount: (cartModel.totalAmount).toStringAsFixed(2)
                              )));
                              //await makePayment();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if(cartModel.cartItems!.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LineIcon.addToShoppingCart(size: 80, color: color3,),
                  SizedBox(height: 14),
                  Text('Your Cart is Empty', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),),
                  SizedBox(height: 10),
                  Text("Looks like you haven't added anything\nto your cart yet", style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16
                  ), textAlign: TextAlign.center,)
                ],
              ),
            );
          }
          else{
            return circularProgress();
          }
        }
    );
  }
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      margin: EdgeInsets.only(top: 15, bottom: 5),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
  ListTile makeListTitle(BuildContext context, model) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(

                alignment: Alignment.center,
                child: Image.network(model.thumbnail.toString(), width: 100,
                  height: 100, fit: BoxFit.cover,),
              ),
              Expanded(
                child: Text(
                  model.variationId == 0 ? '${model.productName}' :
                  '${model.productName} (${model.attribute} ${model
                      .attributeValue}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ), maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text('${model.productSalePrice.toString()}', style: TextStyle(
                color: Colors.black,
              ),),
              //Provider.of<CartProvider>(context, listen: false).updateQty(data!.productId!.toInt(), value, variationId: data!.variationId);
              FlatButton(
                onPressed: () {
                  Utils.showMessage(context, 'Market Uygulaması',
                      'Sepetinizden silmek istediğinize emin misiniz?',
                      'Evet', () {
                        Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
                        Provider.of<CartProvider>(context, listen: false).removeItem(model.productId!);

                        Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);
                        Navigator.of(context).pop();
                      }, buttonText2: 'Hayır',
                      isConfirmationDialog: true,
                      onPressed2: () {
                        Navigator.of(context).pop();
                      });
                },
                shape: StadiumBorder(),
                padding: EdgeInsets.all(8),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.delete, color: Colors.white, size: 20,),
                    Text('Sil', style: TextStyle(
                        color: Colors.white
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  showBottom(context, productId, model) {
    return showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.white,
            child: new CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: 2),
                magnification: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                onSelectedItemChanged: (i) {
                  if(i == 0) {

                  }
                  else {
                    setState(() {
                      model.qty = i;
                    });
                    Provider.of<CartProvider>(context, listen: false).updateQty(productId.toInt(), i);
                  }
                },
                children: List.generate(numberQty + 1, (index) {
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      index.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: index ==  0 ? Colors.white : Colors.black87
                      ),
                    ),
                  );
                }).toList()),);
        }).then((value) {
          setState(() {
            refresh();
       });
    });
  }
}



class UserNotSignIn extends StatefulWidget {
  const UserNotSignIn({Key? key}) : super(key: key);

  @override
  _UserNotSignInState createState() => _UserNotSignInState();
}

class _UserNotSignInState extends State<UserNotSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.3,
        iconTheme: IconThemeData(
          color: Colors.black87
        ),
        backgroundColor: Colors.white,
        title: Text("", style: TextStyle(
            color: Colors.black87,
            fontSize: 17
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LineIcon.lock(size: 80, color: color3,),
            SizedBox(height: 14),
            Text('You must sing-in', style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),),
            SizedBox(height: 10),
            Text("You must sign-in to access to this section", style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16
            ), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 1.7,
              child: FlatButton(
                onPressed: (){
                  Get.offAll(LoginPage());
                },
                child: Text("Sign in", style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500
                ),),
                color: color1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.only(top: 9, bottom: 9),
              ),
            )
          ],
        ),
      ),
    );
  }
}

