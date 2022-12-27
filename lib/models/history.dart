import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? status;
  String? pickup;
  String? dropoff;
  String? fareAmount;
  String? driverName;
  String? driverPhone;
  String? driverPhoto;

  TripsHistoryModel({
    this.time,
    this.status,
    this.pickup,
    this.dropoff,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as dynamic)["time"];
    status = (dataSnapshot.value as dynamic)['status'];
    pickup = (dataSnapshot.value as dynamic)["pickup_address"];
    dropoff = (dataSnapshot.value as dynamic)["dropoff_address"];
    fareAmount = (dataSnapshot.value as dynamic)["fareAmount"];
    driverName = (dataSnapshot.value as dynamic)["driverName"];
    driverPhone = (dataSnapshot.value as dynamic)["driverPhone"];
    driverPhoto = (dataSnapshot.value as dynamic)["driverPhoto"];
  }
}
