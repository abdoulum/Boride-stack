import 'package:boride/dataprovider/appdata.dart';
import 'package:boride/global/global.dart';
import 'package:boride/global/map_key.dart';
import 'package:boride/datamodels/directiondetails.dart';
import 'package:boride/helper/requesthelper.dart';
import 'package:boride/datamodels/address.dart';
import 'package:boride/datamodels/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelperMethod
{
  static Future<String> findCordinateAddress(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String placeAddress ="";

    var requestResponse = await RequestHelper.getRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No Response.")
    {
      placeAddress  = requestResponse["results"][0]["formatted_address"];

      Address userPickUpAddress = Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress ;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress ;
  }

  static Future<DirectionDetails?> getDirectionDetails(LatLng startPosition, LatLng endPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestHelper.getRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetails directionDetailsInfo = DirectionDetails();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static int estimateFares (DirectionDetails directionDetailsInfo) {

    // per km = ₦70,
    // per min = ₦30
    // base fare = ₦200

    double basefare = 200;
    double distanceFare = (directionDetailsInfo.distance_value!/1000) * 20;
    double timeFare = (directionDetailsInfo.duration_value! / 60) * 30;

    double totalFare = basefare + distanceFare + timeFare;

    return totalFare.truncate();
  }


  static void getCurrentUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

}