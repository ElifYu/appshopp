import 'dart:convert';
import 'package:appshop/api_service.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/base_page.dart';
import 'package:appshop/pages/cart_page.dart';
import 'package:appshop/pages/product_details.dart';
import 'package:appshop/pages/widget_category_page.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/provider/flutter_secure_storage.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/rating.dart';
import 'package:appshop/widgets/widget_get_tags.dart';
import 'package:appshop/widgets/widget_home_video.dart';
import 'package:appshop/widgets/widget_product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:appshop/config.dart';
import 'package:line_icons/line_icon.dart';
import 'package:appshop/models/category.dart' as categoryModel;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/products_provider.dart';
import '../utils/colors.dart';




class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {


  APIService? apiService;

  var htmlText;
  List? htmlImageData;
  Future getBannerImages() async{
    try{
      var response = await http.get(Uri.parse("${Config.urlWebSite}/wp-json/wp/v2/pages/${Config.bannerPageId}"),);

      var js = json.decode(response.body);
      print('-------------------------------');
      setState(() {
        htmlText = js['content']['rendered'];
      });
      if(htmlText.isEmpty){
        print('Boşşşş');
        setState(() {
          htmlText = "0";
        });
      }
      else{
        setState(() {
          print(htmlText);
          dom.Document document = parse(htmlText);
          htmlImageData = document.getElementsByTagName('img');
        });

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
  }

  int _page = 1;

  List<Product> featuredProducts = [];

  @override
  void initState() {
    apiService = APIService();
    getBannerImages();
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.cleanSortOrder();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, tagName: Config.homeFeaturedProductsTagId );
    super.initState();
  }

  @override
  Widget pageUI() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: WidgetHomeVideo(
              tagId: Config.videoTagId,
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 20),
                  child: Text('Categories',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),),
                ),

              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 140,
              child: FutureBuilder(
                future: apiService!.getCategories(),
                builder: (BuildContext context, AsyncSnapshot<List<categoryModel.Category>> model,){
                  if(model.hasData) {
                    return buildCategories(model.data);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.grey.shade300,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: 75, height: 75,
                                    color: Colors.grey,
                                  )
                                ),
                                SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(

                                    width: 80,
                                    height: 30,
                                      child: Text('Categorie',
                                      textAlign: TextAlign.center,
                                    ),
                               ),
                                ),
                             ],
                            ),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          htmlText == "0" ?  SliverToBoxAdapter() : htmlImageData == null ?
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade300,
                  child: Container(
                    margin: EdgeInsets.only(top: 7),
                    width: MediaQuery.of(context).size.width,
                    height: 155.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              childCount: 1,
            ),
          ) : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return BannerImagesTop(context, htmlImageData![0].attributes['src'], index);
              },
              childCount: 1,
            ),
          ),

          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 20),
                  child: Text('Featured Products',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),),
                ),

              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height/ 2.15,
              margin: EdgeInsets.only(top: 15),
              child: Consumer<ProductProvider>(
                  builder: (context, productModel, child){
                    if(productModel.allProducts != null &&
                        productModel.allProducts!.length > 0 &&
                        productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL){
                      if(featuredProducts.isEmpty){
                        featuredProducts = productModel.allProducts!;
                        return _buildList(featuredProducts, isLoadMore: productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
                      }
                     else{
                        return _buildList(featuredProducts, isLoadMore: productModel.getLoadMoreStatus() == LoadMoreStatus.INITIAL);
                      }
                    }
                    if(productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL && productModel.allProducts!.length == 0){
                      return featuredProducts.isEmpty ? Container() : _buildList(featuredProducts, isLoadMore: productModel.getLoadMoreStatus() == LoadMoreStatus.INITIAL);
                    }
                   else{
                      return featuredProducts.isNotEmpty ? _buildList(featuredProducts, isLoadMore: productModel.getLoadMoreStatus() == LoadMoreStatus.INITIAL)
                          : Container(
                        height: MediaQuery.of(context).size.height/ 2.15,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (BuildContext context, int index){
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width: 170,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.grey,
                                    ),
                                  )
                              );
                            }
                        ),
                      );
                    }
                  }
              ),
            )
          ),

          htmlText == "0" ?  SliverToBoxAdapter() :
          htmlImageData == null ?  SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade300,
                    child: Container(
                      margin: EdgeInsets.only(top: 7),
                      width: MediaQuery.of(context).size.width,
                      height: 155.0,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                );
              },
              childCount: 3,
            ),
          ) : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return BannerImages(context, htmlImageData![index].attributes['src'], index);
              },
              childCount: htmlImageData!.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 5,),
          )
        ],
      ),
    );
  }

  Widget _buildList(List<Product>? items, {bool? isLoadMore}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: items!.map((Product data)  {
              return GestureDetector(
                  onTap: (){
                    Get.to(ProductDetails(product: data,));
                  },
                  child: Container(
                    width: 180,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(left: 6, bottom: 5, right: 6),
                      elevation: 0.5,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data.images!.length > 0 ?
                            Container(
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5)
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: data.images![0].src.toString(),
                                    fit: BoxFit.cover,width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Container(color: Colors.white,),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                )) :
                            Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height / 3,),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Text('${data.name}', style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15
                              ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child:  ratingWidget(data.averageRating, data.averageRating, 16.0,
                                  Colors.grey.shade400.withOpacity(0.5), Colors.grey[400], 13.0),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Text('\$${data.price}', style: TextStyle(
                                  color: color1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              );
            }).toList(),

          ),
        ),

      ],
    );
  }

  Widget BannerImages(BuildContext context, image, index) {
    return index == 0 ? Container() : InkWell(
      onTap: (){
        dom.Document document = parse(htmlText);
        var tagId = document.getElementsByTagName('figcaption')[index].text;
        print(tagId);
        Get.to(
            WidgetHomeProducts(
              tagId: tagId,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 155.0,
        margin: EdgeInsets.only(top: 7),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.white,),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget BannerImagesTop(BuildContext context, image, index) {
    return InkWell(
      onTap: (){
        dom.Document document = parse(htmlText);
        var tagId = document.getElementsByTagName('figcaption')[index].text;
        print(tagId);
        Get.to(
            WidgetHomeProducts(
              tagId: tagId,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 155.0,
        margin: EdgeInsets.only(top: 7),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.white,),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  buildCategories(List<categoryModel.Category>? categories) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: categories!.map((e) => e.categoryId == 15 ?
        Container(width: 0, height: 0,) :
        GestureDetector(
          onTap: (){
            Get.to(ProductPage(
              categoryId: e.categoryId.toString(),
              categoryName: e.categoryName,
            ));
         },
          child: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                e.image == null ? Container(
                  child: Center(
                    child: LineIcon.image(),
                  ),
                ) :
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: '${e.image!.url}',
                    fit: BoxFit.cover,
                    width: 75, height: 75,
                    placeholder: (context, url) => Container(color: Colors.white,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Container(
                    width: 80,
                    height: 30,
                    child: Center(child: Text('${e.categoryName}'))),
              ],
            ),
          ),
        ),
        ).toList(),
      ),
    );
  }
}
