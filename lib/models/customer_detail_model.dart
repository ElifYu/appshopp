class CustomerDetailModel {
  int? id;
  String? firstName;
  String? lastName;
  Billing? billing;
  Shipping? shipping;


  CustomerDetailModel({
    this.shipping,
    this.billing,
    this.id,
    this.lastName,
    this.firstName
  });

  CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    billing = json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
  }
}

class Billing{
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;
  String? email;
  String? phone;

  Billing({
    this.lastName,
    this.firstName,
    this.address1,
    this.city,
    this.email,
    this.address2,
    this.company,
    this.country,
    this.phone,
    this.postCode,
    this.state
});

  Billing.fromJson(Map<String, dynamic> json){
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    postCode = json['postcode'];
    country = json['country'];
    state = json['state'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['postcode'] = this.postCode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}


class Shipping{
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;

  Shipping({
    this.lastName,
    this.firstName,
    this.address1,
    this.city,
    this.address2,
    this.company,
    this.country,
    this.postCode,
    this.state
  });

  Shipping.fromJson(Map<String, dynamic> json){
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    postCode = json['postcode'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['postcode'] = this.postCode;
    data['country'] = this.country;
    data['state'] = this.state;
    return data;
  }
}
