import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

write(jwt, userName, userEmail, userFirstName, userLastName) async{
  await storage.write(key: "jwt", value: jwt);
  await storage.write(key: "userName", value: userName);
  await storage.write(key: "userEmail", value: userEmail);
  await storage.write(key: "userFirstName", value: userFirstName);
  await storage.write(key: "userLastName", value: userLastName);
  read();
}

var jwt;
var userName;
var userEmail;
var userFirstName;
var userLastName;


Future read() async{
  jwt = await storage.read(key: "jwt");
  userName = await storage.read(key: "userName");
  userEmail = await storage.read(key: "userEmail");
  userFirstName = await storage.read(key: "userFirstName");
  userLastName = await storage.read(key: "userLastName");
}

delete() async{
  await storage.delete(key: "jwt");
  await storage.delete(key: "userName");
  await storage.delete(key: "userEmail");
  await storage.delete(key: "userFirstName");
  await storage.delete(key: "userLastName");
  jwt = null;
  userName = null;
  userEmail = null;
  userFirstName = null;
  userLastName = null;
}