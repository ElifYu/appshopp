import 'dart:convert';

import 'package:appshop/api_service.dart';
import 'package:appshop/config.dart';
import 'package:appshop/models/get_comments.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/pages/widget_add_comment.dart';
import 'package:appshop/provider/comments_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/rating.dart';
import 'package:appshop/widgets/widget_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';


class GetAllComments extends StatefulWidget {
  final productId;
  final image;
  final text;
  final rating;
  GetAllComments({Key? key, this.productId, this.image, this.text, this.rating}) : super(key: key);

  @override
  _GetAllCommentsState createState() => _GetAllCommentsState();
}

class _GetAllCommentsState extends State<GetAllComments> {

  APIService? apiService;
  int _page = 1;
  ScrollController _scrollController = ScrollController();


  var selectedIndex;

  @override
  void initState() {
    var productList = Provider.of<ProductProviderComments>(context, listen: false);
    productList.resetStreamsComments();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchComments(_page, productID: widget.productId);


    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchComments(++_page, productID: widget.productId);
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          titleSpacing: 5,
          elevation: 0.3,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: LineIcon.arrowLeft(color: Colors.black87, size: 30,),
            onPressed: (){
              Get.back();
            },
          ),
          title: Text("Reviews".toUpperCase(), style: TextStyle(
              color: Colors.black87,
              fontSize: 17
          ),)

        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey.shade300)
              )
          ),
          width: MediaQuery.of(context).size.width / 1.7,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: FlatButton(
            onPressed: () {
              Get.to(AddComment(productId: widget.productId,));
            },
            child: Text("Add a comment", style: TextStyle(
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
        ),
        body: Consumer<ProductProviderComments>(
            builder: (context, productModel, child){
              if(productModel.allProductsComments != null &&
                  productModel.allProductsComments!.length > 0 &&
                  productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL){
                return _buildList(productModel.allProductsComments, productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
              }
              if(productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL && productModel.allProductsComments!.length == 0){
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
                        Text('No reviews found',
                          textAlign: TextAlign.center,)
                      ],
                    )
                );
              }
              return circularProgress();
            }
        ),
    );
  }
  Widget _buildList(List<GetComments>? model, bool isLoadMore){
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                    child: Image.network(widget.image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.text, style: TextStyle(
                             fontSize: 18,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500
                    ), maxLines: 2),
                        ratingDetailWidget(widget.rating),
                      ],
                    ),
           )),
            ],
          )
        ),
        SliverList(
    delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 3, top: 5),
            child: ratingDetailWidget(model![index].rating.toString()),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Text(model[index].reviewer + ' | '
                    + model[index].dateCreated.day.toString() + '/' +
                    model[index].dateCreated.month.toString() + '/' +
                    model[index].dateCreated.year.toString() + ' | ' +
                    model[index].dateCreated.hour.toString() + ':' +
                    model[index].dateCreated.minute.toString(),
                  maxLines: 2, overflow: TextOverflow.ellipsis,),
              ),
              DescriptionTextWidget(text: model[index].review,)

            ],
          ),
        ),
      );
    },
    childCount: model!.length,
     ),
    ),
        SliverToBoxAdapter(
          child: Visibility(
            child: LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: color1,
              valueColor: AlwaysStoppedAnimation<Color>(color3),
            ),
            visible: isLoadMore,
          )
        )
      ],
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String? text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text!.length > 200) {
      firstHalf = widget.text!.substring(0, 50);
      secondHalf = widget.text!.substring(50, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      child: secondHalf!.isEmpty
          ? Html(
          data: firstHalf)
          : Column(
        children: <Widget>[
          Html(
            data: flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? "Show all" : "Show less",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}

