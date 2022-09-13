import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

ratingWidget(rating, averageRating, size, ratingSolidColor, textColor, textSize) {
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      RatingBarIndicator(
        rating: double.parse(rating),
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        unratedColor: ratingSolidColor,
        itemCount: 5,
        itemSize: size,
        direction: Axis.horizontal,
      ),
      Text(' (' + averageRating + ') ', style: TextStyle(
          color: textColor,
          fontSize: textSize,
          fontWeight: FontWeight.w600
      ),)
    ],
  );
}

ratingDetailWidget(rating) {
  return RatingBarIndicator(
    rating: double.parse(rating),
    itemBuilder: (context, index) => Icon(
      Icons.star,
      color: Colors.yellow,
    ),
    unratedColor: Colors.grey[400],
    itemCount: 5,
    itemSize: 20.0,
    direction: Axis.horizontal,
  );
}