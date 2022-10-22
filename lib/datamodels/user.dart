import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? fullName;
  String? email;
  String? phone;
  String? id;

  UserModel({
    this.fullName,
    this.email,
    this.phone,
    this.id,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    id = snap.key;
    phone = (snap.value as dynamic)["phone"];
    fullName = (snap.value as dynamic)["name"];
    email = (snap.value as dynamic)["email"];
  }
}
