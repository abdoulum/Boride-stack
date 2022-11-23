import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? pickup;
  String? dropoff;
  String? fareAmount;
  String? driverName;
  String? driverPhone;

  TripsHistoryModel({
    this.time,
    this.pickup,
    this.dropoff,
    this.driverName,
    this.driverPhone,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot)
  {
    time = (dataSnapshot.value as dynamic)["time"];
    pickup = (dataSnapshot.value as dynamic)["pickup_address"];
    dropoff = (dataSnapshot.value as dynamic)["dropoff_address"];
    fareAmount = (dataSnapshot.value as dynamic)["fareAmount"];
    driverName = (dataSnapshot.value as dynamic)["driverName"];
    driverPhone = (dataSnapshot.value as dynamic)["driverPhone"];
  }
}