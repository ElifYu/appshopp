// @dart=2.9
import 'package:appshop/pages/base_page.dart';
import 'package:appshop/pages/bottom_bar_page.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/widget_get_comments.dart';
import 'package:appshop/pages/login_page.dart';
import 'package:appshop/pages/onboard_page.dart';
import 'package:appshop/pages/orders_page.dart';
import 'package:appshop/pages/product_details.dart';
import 'package:appshop/pages/widget_category_page.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/comments_provider.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/provider/order_provider.dart';
import 'package:appshop/provider/products_provider.dart';
import 'package:appshop/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'your-publishableKey';
  Stripe.merchantIdentifier = 'string';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  userIsLogin(){
    read().then((value) {
      if (jwt == null) {
        Get.offAll(OnBoardPage());
      } else {
        Get.offAll(BottomBarPage());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIsLogin();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: ProductPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductDetailsWidget(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrdersPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProviderComments(),
          child: GetCommentsWidget(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Appshop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}



//


