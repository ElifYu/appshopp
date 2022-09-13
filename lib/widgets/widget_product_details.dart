import 'package:appshop/api_service.dart';
import 'package:appshop/models/cart_request_model.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/models/variable_product.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/expand_text.dart';
import 'package:appshop/utils/getx_snackbar.dart';
import 'package:appshop/utils/image_zoom.dart';
import 'package:appshop/utils/rating.dart';
import 'package:appshop/widgets/widget_related_products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import '../pages/widget_get_comments.dart';
import '../provider/cart_provider.dart';


class ProductDetailsWidget extends StatelessWidget {
  Product? data;
  final CarouselController _controller = CarouselController();
  int qty = 0;
  ProductDetailsWidget({Key? key, this.data, this.variableProducts}) : super(key: key);
  List<VariableProduct>? variableProducts;
  CartProducts cartProducts = CartProducts();


  APIService? apiService;

  var ind;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                  stretch: false,
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.grey[50],
                  expandedHeight: MediaQuery.of(context).size.height / 1.7,
                  floating: false, pinned: true, snap: false,
                  actions: [
                    SizedBox(width: 15),
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(9),
                          child: LineIcon.arrowLeft(color: Colors.grey[700], size: 30,),
                   )),
                    Spacer(),


                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      background: productImages(data!.images!.toList(), context),
               )
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 1.0,
                                    offset: Offset(0.0, 0.1)
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(data!.name.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.grey[800],
                                  ),),
                                Divider(),
                                Row(
                                  children: [
                                  Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(data!.averageRating.toString(), style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600
                                    ),),
                                    SizedBox(width: 7),
                                   ratingDetailWidget(data!.averageRating.toString()),
                                  ],
                                ),
                                    Spacer(),
                                    Visibility(
                                      visible: data!.calculateDiscount() > 0,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                              color: Colors.green
                                          ),
                                          child: Text('${data!.calculateDiscount()}% OFF',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                            ),),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                         Container(
                           width: MediaQuery.of(context).size.width,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             boxShadow: <BoxShadow>[
                               BoxShadow(
                                   color: Colors.grey.shade400,
                                   blurRadius: 1.0,
                                   offset: Offset(0.0, 0.1)
                               )
                             ],
                           ),
                           padding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                           child: ExpandText(
                             labelHeader: 'About Product',
                             shortDesc: data!.shortDescription,
                             desc: data!.description,
                           ),
                         ),
                          SizedBox(height: 10),
                          data!.type == 'variable' ? Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 1.0,
                                    offset: Offset(0.0, 0.1)
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 7, bottom: 10),
                                  child: Text('Attributes', style: TextStyle(
                                      fontSize: 17,
                                      color: color1,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data!.attributes!.map((e) {
                                    return Row(

                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
                                          child: Text(e.name.toString(), style: TextStyle(
                                            fontWeight: FontWeight.w500
                                          ),),
                                        ),
                                        Spacer(),
                                        Wrap(
                                          children: e.options!.map((e) {
                                            return Container(
                                                padding: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
                                                margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black12),
                                                    borderRadius: BorderRadius.circular(4)
                                                ),
                                                child: Text(e),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                          ) : Container(),
                          SizedBox(height: 10),
                          GetCommentsWidget(
                            productId: data!.id,
                            image: data!.images![0].src,
                            text: data!.name,
                            rating: data!.averageRating,
                          ),
                          SizedBox(height: 10),
                          Container(
                           width: MediaQuery.of(context).size.width,
                           height: MediaQuery.of(context).size.height / 1.6,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             boxShadow: <BoxShadow>[
                               BoxShadow(
                                   color: Colors.grey.shade400,
                                   blurRadius: 1.0,
                                   offset: Offset(0.0, 0.1)
                               )
                             ],
                           ),
                             padding: EdgeInsets.only(top: 15, left: 5),
                           child: SingleChildScrollView(
                             physics: NeverScrollableScrollPhysics(),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(left: 7, bottom: 3),
                                   child: Text('Related Products', style: TextStyle(
                                       fontSize: 17,
                                       color: color1,
                                       fontWeight: FontWeight.w500
                                   ),
                                   ),
                                 ),
                                 WidgetRelatedProducts(
                                   products: this.data!.relatedIds,
                                 ),
                               ],
                             ),
                           )
                         )
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade300)
                  )
              ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 20, top: 10, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        data!.regularPrice!.isEmpty ? Container() :
                        Text('\$${data!.regularPrice.toString()}', style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough
                        ), maxLines: 2,),
                        Text('\$${data!.price.toString()}', style: TextStyle(
                            fontSize: 15,
                            color: color1,
                            fontWeight: FontWeight.w500
                        ), maxLines: 2,),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width /2,
                    child: FlatButton(
                      onPressed: (){
                        read().then((value) {
                          if(jwt == null){
                            snackBarWarning('You must login', 'You must be logged in to add the product to your cart.');
                          }
                          else{

                            if(data!.type == 'variable'){
                              bottomSheet(context);
                            }
                            else {
                              snackBarLoading('Please Wait', "The product is being added to your cart");
                              Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
                              var cartProvider = Provider.of<CartProvider>(context, listen: false);
                              cartProducts.productId = data!.id;
                              cartProducts.quantity = 1;
                              cartProducts.variationId = 0;

                              cartProvider.addToCart(cartProducts, (val) {
                                Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);
                              });
                            }
                          }
                        });

                      },
                     child: Text("Add To Cart", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),),
                      color: color1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.only(top: 13, bottom: 13),
                    ),
                  )
                ],
              ),
            )
          ),
        )
      ],
    );
  }
  var empty;
  Widget productImages(List<Images> images, BuildContext context) {
    return Carousel(
      images: images.map((e) {
        return GestureDetector(
          onTap: (){
            Get.to(InteractiveImage(image: e.src));
          },
          child: Container(
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black38, Colors.black26, Colors.transparent, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.1, 0.8, 1],
              ),
            ),
            child: Image.network(e.src.toString(),
              fit: BoxFit.contain,
              errorBuilder: (BuildContext context, Object? exception, StackTrace? stackTrace) {
                return Container(color: Colors.white,);
              },),
          ),
        );
      }).toList(),
      dotSize: 5.0,
      autoplay: false,
      dotSpacing: 20.0,
      dotColor: Colors.grey[300],
      indicatorBgPadding: 9.0,
      dotIncreasedColor: color1,
      dotBgColor: Colors.transparent,
      borderRadius: true,
    );
  }

   Widget selectDropDown(
      BuildContext context,
      Object initialValue,
      dynamic data,
      Function? onChange, {
        Function? onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: DropdownButtonFormField<VariableProduct>(
          hint: Text('Select'),
          isDense: true,
          value: empty,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (VariableProduct? newValue){
            FocusScope.of(context).requestFocus(FocusNode());
            onChange!(newValue);
            print(newValue);
            empty = newValue;
          },
          items: data != null ?
          data.map<DropdownMenuItem<VariableProduct>>((VariableProduct data){
            return DropdownMenuItem(
              value: data,
              child: Text('${data.attributes!.first.option! + " " + data.attributes!.first.name.toString()}',
              style: TextStyle(
                color: Colors.black
              ),),
            );
           },
          ).toList()
         : null
      ),)
    );
  }

  static InputDecoration fieldDecoration(
      BuildContext context,
      String hintText,
      String helperText, {
        Widget? prefixIcon,
        Widget? suffixIcon
    }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1
        )
      )
    );
  }


  bottomSheet(context){
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                apiService = APIService();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 7, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(data!.name.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),),
                            ),
                            IconButton(
                              icon: LineIcon.times(
                                color: Colors.grey[600],),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, top: 8, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue,
                                      image: DecorationImage(
                                          image: NetworkImage(data!.images![0].src.toString()),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Text(data!.price.toString(), style: TextStyle(
                                    color: color1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: variableProducts!.map((VariableProduct element) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        this.data!.price = element.price;
                                        this.data!.variableProduct = element;
                                        cartProducts.variationId = element.id;
                                        ind = element.id;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color:
                                          ind == element.id ? color1 :
                                          Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(5),
                                          color: ind == element.id ? color3 : Colors.white
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: element.attributes!.map((e) {
                                          return Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: InkWell(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.name.toString()),
                                                  Text(e.option.toString()),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
                        child: FlatButton(
                          onPressed: (){
                            read().then((value) {
                              if(jwt == null){
                                snackBarWarning('You must login', 'You must be logged in to add the product to your cart.');
                              }
                              else{
                                snackBarLoading('Please Wait', "The product is being added to your cart");
                                Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(true);
                                var cartProvider = Provider.of<CartProvider>(context, listen: false);
                                cartProducts.productId = data!.id;
                                cartProducts.variationId = data!.variableProduct!.id;
                                cartProducts.quantity = 1;
                                cartProvider.addToCart(cartProducts, (val) {
                                  Provider.of<LoaderProvider>(context, listen: false).setLoafingStatus(false);
                                  print(val);
                                });
                              }
                            });

                          },
                          child: Text("Add To Cart", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),),
                          color: color1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.only(top: 13, bottom: 13),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}