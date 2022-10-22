import 'package:boride/datamodels/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier
{
  Address? pickupAddress, destinationAddress;


  void updatePickUpLocationAddress(Address userPickUpAddress)
  {
    pickupAddress = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress)
  {
    destinationAddress = dropOffAddress;
    notifyListeners();
  }

}