class CartRequestModel{
  int? userId;
  String? addNewCart;
  List<CartProducts>? products;

  CartRequestModel({this.products, this.userId, this.addNewCart});

  CartRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    addNewCart = json['add_new_cart'];
    if(json['products'] != null) {
      products = <CartProducts>[];
      json['products'].forEach((v) {
        products!.add(CartProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['add_new_cart'] = this.addNewCart;
    if(this.products != null){
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartProducts{
  int? productId;
  int? quantity;
  int? variationId = 0;

  CartProducts({this.productId, this.quantity, this.variationId});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['variation_id'] = this.variationId;
    return data;
  }

}

