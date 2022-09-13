import 'package:appshop/models/variable_product.dart';

class Product{
  int? id;
  String? name;
  String? description;
  String? shortDescription;
  String? sku;
  String? price;
  String? regularPrice;
  String? stockStatus;
  String? salePrice;
  List<Images>? images;
  List<Categories>? categories;
  List<Attributes>? attributes;
  List<int>? relatedIds;
  String? type;
  String? averageRating;
  VariableProduct? variableProduct;
  List<Video>? video;

  Product({
    this.categories,
    this.id,
    this.description,
    this.name,
    this.price,
    this.regularPrice,
    this.shortDescription,
    this.sku,
    this.salePrice,
    this.images,
    this.stockStatus,
    this.attributes,
    this.relatedIds,
    this.type,
    this.variableProduct,
    this.video,
    this.averageRating
});

  Product.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'] != "" ? json['sale_price'] : json['regular_price'];

    stockStatus = json['stock_status'];
    averageRating = json['average_rating'];
    type = json['type'];
    relatedIds = json['cross_sell_ids'].cast<int>();

    if(json['categories'] != null){
      categories = <Categories>[];
      json['categories'].forEach((v){
        categories!.add(Categories.fromJson(v));
      });
    }

    if(json['images'] != null){
      images = <Images>[];
      json['images'].forEach((v){
        images!.add(Images.fromJson(v));
      });
    }
    if(json['attributes'] != null){
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    if(json['meta_data'] != null){
      video = <Video>[];
      json['meta_data'].forEach((v) {
        video!.add(Video.fromJson(v));
      });
    }
  }

  calculateDiscount() {
    double disPercent = 0;
    if(this.regularPrice != "") {
      double regularPrice = double.parse(this.regularPrice ?? "");
      double salePrice = this.salePrice != "" ? double.parse(this.salePrice ?? "") : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }
    return disPercent.round();
  }

  calculateDiscountVariation() {
    double disPercent = 0;
    if(this.variableProduct!.regularPrice != "") {
      double regularPrice = double.parse(this.variableProduct!.regularPrice ?? "");
      double salePrice = this.variableProduct!.salePrice != "" ? double.parse(this.variableProduct!.salePrice ?? "") : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }
    return disPercent.round();
  }
}

class Categories{
  int? id;
  String? name;

  Categories({
    this.name,
    this.id
});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Images{
  String? src;

  Images({
    this.src
  });

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}

class Attributes{
  int? id;
  String? name;
  List<String>? options;

  Attributes({this.id, this.options, this.name});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    options = json['options'].cast<String>();
  }
}

class Video{
  String? value;

  Video({this.value});

  Video.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }
}