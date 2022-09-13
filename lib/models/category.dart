
class Category {
  int? categoryId;
  String? categoryName;
  String? categoryDesc;
  int? parent;
  Image? image;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryDesc,
    this.parent,
    this.image
  });

  Category.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    categoryId =  json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent = json['parent'];
  }
}

class Image{
  String? url;

  Image({
    this.url
  });

  Image.fromJson(Map<String, dynamic> json) {
    url = json['src'];
  }

}