

import 'dart:convert';

class LoginResponseModel {
  bool? success;
  int? statusCode;
  String? code;
  String? message;
  Data? data;

  LoginResponseModel({
    this.data,
    this.statusCode,
    this.code,
    this.message,
    this.success
});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode =  json['statusCode'];
    code = json['code'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.data;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    data['success'] = this.success;

    if(this.data != null){
      data['data'] = this.data!.toJson();
    }

    return data;
  }
}

class Data{
  String? token;
  int? id;
  String? email;
  String? nicename;
  String? firstName;
  String? lastName;
  String? displayName;

  Data({
    this.email,
    this.firstName,
    this.id,
    this.displayName,
    this.lastName,
    this.nicename,
    this.token
});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id =  json['id'];
    email = json['email'];
    nicename = json['nicename'];
    firstName = json['firstName'];
    displayName = json['displayName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.nicename;
    data['firstName'] = this.firstName;
    data['displayName'] = this.displayName;
    data['lastName'] = this.lastName;

    return data;
  }
}