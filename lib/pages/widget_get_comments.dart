// @dart=2.9
import 'dart:convert';

import 'package:appshop/api_service.dart';
import 'package:appshop/models/get_comments.dart';
import 'package:appshop/pages/widget_add_comment.dart';
import 'package:appshop/pages/widget_all_comments_page.dart';
import 'package:appshop/provider/comments_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';


class GetCommentsWidget extends StatefulWidget {
  final productId;
  final image;
  final text;
  final rating;
  const GetCommentsWidget({Key key, this.productId, this.text, this.image, this.rating}) : super(key: key);

  @override
  _GetCommentsWidgetState createState() => _GetCommentsWidgetState();
}

class _GetCommentsWidgetState extends State<GetCommentsWidget> {

  int _page = 1;
  APIService apiService;

  @override
  void initState() {
    // TODO: implement initState
    apiService = APIService();
    super.initState();
    var productList = Provider.of<ProductProviderComments>(context, listen: false);
    productList.resetStreamsComments();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchComments(_page, productID: widget.productId);

  }
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(bottom: 5),
      child: Consumer<ProductProviderComments>(
          builder: (context, productModel, child){
            if(productModel.allProductsComments != null &&
                productModel.allProductsComments.length > 0 &&
                productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL){
              return Container(
                  height: 220,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 19, right: 5),
                        child: Row(
                          children: [
                            Text('Product Reviews', style: TextStyle(
                                fontSize: 17,
                                color: color1,
                                fontWeight: FontWeight.w500
                            ),),
                            Spacer(),
                            TextButton(
                              child: Text('See All'),
                              onPressed: (){
                                Get.to(GetAllComments(
                                  productId: widget.productId,
                                  image: widget.image,
                                  text: widget.text,
                                  rating: widget.rating,
                                ));
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildComments(productModel.allProductsComments),
                      )
                    ],
                  )
              );
            }
            if(productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL && productModel.allProductsComments.length == 0){
              return Center(
                child: Container(
                    height: 150,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 5),
                        Text('No comments yet',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                          ),
                          textAlign: TextAlign.center,),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: FlatButton(
                            onPressed: (){
                              Get.to(AddComment(productId: widget.productId,));
                            },
                            child: Text('Add a comment', style: TextStyle(
                                color: color1,
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),),
                            color: color2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                          ),
                        )
                      ],
                    )
                ),
              );
            }
            return Center(
              child: Container(
                height: 200,
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
                child: circularProgress()
              ),
            );
          }
      ),
    );
  }

  _buildComments(List<GetComments> model){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: model.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          width: 250,
          margin: EdgeInsets.only(left: 17, bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            title:
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 5),
              child: ratingDetailWidget(model[index].rating.toString()),
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
                Html(
                  data: model[index].review,
                  style: {
                    '#': Style(
                      maxLines: 3,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
