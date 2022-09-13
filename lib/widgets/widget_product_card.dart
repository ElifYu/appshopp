import 'package:appshop/models/product.dart';
import 'package:appshop/pages/product_details.dart';
import 'package:appshop/utils/rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';


class ProductCard extends StatelessWidget {
  Product? data;
  ProductCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(ProductDetails(product: data));
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
                data!.images!.length > 0 ?
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
                      imageUrl: data!.images![0].src.toString(),
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
                  child: Text('${data?.name}', style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15
                  ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child:  ratingWidget(data!.averageRating, data!.averageRating, 16.0,
                      Colors.grey.shade400.withOpacity(0.5), Colors.grey[400], 13.0),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: Text('\$${data!.price}', style: TextStyle(
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
  }
}