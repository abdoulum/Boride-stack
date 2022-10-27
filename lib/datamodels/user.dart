import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? email;
  String? id;
  String? name;
  String? phone;

  UserModel({
    this.email,
    this.id,
    this.name,
    this.phone,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    email = (snap.value as dynamic)["email"];
    id = snap.key;
    name = (snap.value as dynamic)["name"];
    phone = (snap.value as dynamic)["phone"];
  }
}
