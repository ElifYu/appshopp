class VariableProduct{
  int? id;
  String? sku;
  String? price;
  String? regularPrice;
  String? salePrice;
  List<Attributes>? attributes;

  VariableProduct({
    this.price,
    this.id,
    this.salePrice,
    this.attributes,
    this.regularPrice,
    this.sku
});

  VariableProduct.fromJson(Map<String, dynamic> json){
    id = json['id'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
   if(json['attributes'] != null) {
     attributes = <Attributes>[];
     json['attributes']!.forEach((v) {
       attributes!.add(Attributes.fromJson(v));
    });
   }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if(this.attributes != null){
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes{
  int? id;
  String? name;
  String? option;

  Attributes({this.id, this.name, this.option});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['option'] = this.option;
    return data;
  }
}
