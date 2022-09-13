// @dart=2.9

class GetComments {
  GetComments({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.productId,
    this.productName,
    this.productPermalink,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.rating,
    this.verified,
    this.reviewerAvatarUrls,
    this.links,
  });

  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  int productId;
  String productName;
  String productPermalink;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  int rating;
  bool verified;
  Map<String, String> reviewerAvatarUrls;
  Links links;

  factory GetComments.fromJson(Map<String, dynamic> json) {
    return GetComments(
      id: json["id"],
      dateCreated: DateTime.parse(json["date_created"]),
      dateCreatedGmt: DateTime.parse(json["date_created_gmt"]),
      productId: json["product_id"],
      productName: json["product_name"],
      productPermalink: json["product_permalink"],
      status: json["status"],
      reviewer: json["reviewer"],
      reviewerEmail: json["reviewer_email"],
      review: json["review"],
      rating: json["rating"],
      verified: json["verified"],
      reviewerAvatarUrls: Map.from(json["reviewer_avatar_urls"]).map((k, v) => MapEntry<String, String>(k, v)),
      links: Links.fromJson(json["_links"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_created": dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt.toIso8601String(),
    "product_id": productId,
    "product_name": productName,
    "product_permalink": productPermalink,
    "status": status,
    "reviewer": reviewer,
    "reviewer_email": reviewerEmail,
    "review": review,
    "rating": rating,
    "verified": verified,
    "reviewer_avatar_urls": Map.from(reviewerAvatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "_links": links.toJson(),
  };
}

class Links {
  Links({
    this.self,
    this.collection,
    this.up,
    this.reviewer,
  });

  List<Collection> self;
  List<Collection> collection;
  List<Collection> up;
  List<Reviewer> reviewer;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    up: List<Collection>.from(json["up"].map((x) => Collection.fromJson(x))),
    reviewer: List<Reviewer>.from(json["reviewer"].map((x) => Reviewer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
    "up": List<dynamic>.from(up.map((x) => x.toJson())),
    "reviewer": List<dynamic>.from(reviewer.map((x) => x.toJson())),
  };
}

class Collection {
  Collection({
    this.href,
  });

  String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class Reviewer {
  Reviewer({
    this.embeddable,
    this.href,
  });

  bool embeddable;
  String href;

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    embeddable: json["embeddable"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable,
    "href": href,
  };
}
