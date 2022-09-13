import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/search_page.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/provider/loader_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';


class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {

  bool isApiCallProcess = false;

  readCartLength(){
    return Provider.of<CartProvider>(context, listen: false).cartItems.toString();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<CartProvider>(context, listen: false).cartItems!.length.toString());
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ProgressHUD(
            child: pageUI(),
            inAsyncCall: loaderModel.isApiCallProgress,
            opacity: 0.3,
          ),
        );
      }
    );
  }
  _buildAppBar(){
    return  AppBar(
      elevation: 0.3,
      titleSpacing: 5,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      toolbarHeight: 65,
      title: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(13),
          ),
          child: InkWell(
            onTap: () {
              Get.to(WidgetSearchPage());
            },
            borderRadius: BorderRadius.circular(13),
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xFF424874),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Search products',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )),
      actions: [

      ],
    );
  }

  Widget? pageUI(){
    return null;
  }
}
