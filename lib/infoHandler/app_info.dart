import 'package:boride/models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:boride/models/directions.dart';

class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation; //endTripLocation
  int countTotalTrips = 0;

  List<String> tripsKeys = [];
  List<TripsHistoryModel> tripsData = [];



  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateOverAllTripsCounter(int overAllTripsCounter)
  {
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripsKeys = newKeys;
    notifyListeners();

  }
  void updateTripsData(TripsHistoryModel tripHistoryModel) {
    tripsData.add(tripHistoryModel);
    notifyListeners();

  }



}