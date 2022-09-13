import 'package:appshop/api_service.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/widgets/widget_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class WidgetRelatedProducts extends StatefulWidget {
  String? labelName;
  List<int>? products;
  WidgetRelatedProducts({Key? key, this.labelName, this.products}) : super(key: key);

  @override
  _WidgetRelatedProductsState createState() => _WidgetRelatedProductsState();
}

class _WidgetRelatedProductsState extends State<WidgetRelatedProducts> {

  APIService? apiService;
  ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    apiService = APIService();
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.cleanSortOrder();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, productsIDs: this.widget.products);

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page, productsIDs: this.widget.products);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  _productsList();
  }
  Widget _productsList() {
    return Consumer<ProductProvider>(
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
    );
  }

  Widget _buildList(List<Product>? items, bool isLoadMore){

    return Container(
      height: MediaQuery.of(context).size.height/ 2,
      child: ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: items!.length,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ProductCard(data: items[index],),
                );
              }
          ),
          Container(
            width: 40,
            child: Visibility(
              child: circularProgress(),
              visible: isLoadMore,
            ),
          )
        ],
      ),
    );
  }
}
