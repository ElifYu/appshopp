import 'dart:convert';

import 'package:appshop/api_service.dart';
import 'package:appshop/config.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/search_page.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/widgets/widget_product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class WidgetHomeProducts extends StatefulWidget {
  String? tagId;
  WidgetHomeProducts({Key? key, this.tagId}) : super(key: key);

  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {

  APIService? apiService;
  int _page = 1;
  ScrollController _scrollController = ScrollController();

  final _sortByOptions = [
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("rating", "Popularity", "desc"),
    SortBy("include", "Latest", "desc"),
    SortBy("price", "Price: Low to high", "asc"),
  ];

  var selectedIndex;

  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.cleanSortOrder();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, tagName: this.widget.tagId.toString());

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page, tagName: this.widget.tagId.toString());
      }
    });
    print(widget.tagId);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 5,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          toolbarHeight: 65,
          leading: IconButton(
            icon: LineIcon.arrowLeft(color: Colors.black87, size: 30,),
            onPressed: (){
              Get.back();
            },
          ),
          title: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
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

        ),
      body: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
                top: BorderSide(color: Colors.grey.shade200),
              )
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _sortByOptions.map((item) {
                return GestureDetector(
                  onTap: (){
                    var empty;
                    setState(() {
                      _page = 1;
                      selectedIndex = item.text;
                    });
                    var productList = Provider.of<ProductProvider>(context, listen: false);
                    productList.resetStreams();
                    productList.setLoadingState(LoadMoreStatus.INITIAL);
                    productList.setSortOrder(item ?? empty);
                    productList.fetchProducts(_page, tagName: this.widget.tagId.toString());
                  },
                  child: selectedIndex == item.text ?
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 2),
                        decoration: BoxDecoration(
                            color: color3,
                            border: Border.all(color: color2),
                            borderRadius: BorderRadius.circular(90)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13, right: 9, bottom: 7, top: 7),
                          child: Row(
                            children: [
                              Text(item.text),
                              SizedBox(width: 4,),
                              LineIcon.angleRight(size: 15, color: color1,),
                            ],
                          ),
                        )),
                  ) :
                  Center(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(90)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13, right: 9, bottom: 7, top: 7),
                          child: Row(
                            children: [
                              Text(item.text),
                              SizedBox(width: 4,),
                              LineIcon.angleRight(size: 15, color: color2,),
                            ],
                          ),
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
                builder: (context, productModel, child){
                  if(productModel.allProducts != null &&
                      productModel.allProducts!.length > 0 &&
                      productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL){
                    return _buildList(productModel.allProducts, productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
                  }
                  if(productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL && productModel.allProducts!.length == 0){
                    return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Oops!', style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25
                            ),),
                            SizedBox(height: 15),
                            Text('No products found',
                              textAlign: TextAlign.center,)
                          ],
                        )
                    );
                  }
                  return circularProgress();
                }
            ),
          ),
        ],
      )
    );
  }
  Widget _buildList(List<Product>? items, bool isLoadMore){

    return Column(
      children: [
        Flexible(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 4.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 0.1),
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: items!.length,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ProductCard(data: items[index],),
                );
              }
          ),
        ),
        Visibility(
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: color1,
            valueColor: AlwaysStoppedAnimation<Color>(color3),
          ),
          visible: isLoadMore,
        )
      ],
    );
  }
}