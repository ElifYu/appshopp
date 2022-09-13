import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/home_page.dart';
import 'package:appshop/pages/orders_page.dart';
import 'package:appshop/pages/profile_page.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/colors.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({Key? key}) : super(key: key);

  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;

//class variable
  final _screens = [
    HomePage(),
    CartPage(),
    WidgetProfilePage(), //OrdersPage
  ];


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: IndexedStack(
          index: selectedIndex,
          children:  _screens
        ),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: color1,
          strokeColor: Color(0x30040307),
          unSelectedColor: Color(0xffacacac),
          backgroundColor: Colors.grey.shade100,
          items: [
            CustomNavigationBarItem(
              icon: LineIcon.home(),
            ),
            CustomNavigationBarItem(
              icon: Stack(
                children: [
                  LineIcon.shoppingCart(size: 34,),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.only(left: 4, right: 4, top: 1.5, bottom: 2),
                        decoration: BoxDecoration(
                            color: color1,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Text(Provider.of<CartProvider>(context, listen: false).cartItems!.length.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white
                        ), textAlign: TextAlign.center,),
                      ),
                    ),
                  )
                ],
              ),
            ),
            CustomNavigationBarItem(
              icon: LineIcon.userAlt(),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        )
      ),
    );
  }
}
