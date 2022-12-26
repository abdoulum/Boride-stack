import 'dart:convert';
import 'dart:math';

import 'package:boride/assistants/app_info.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/assistants/map_key.dart';
import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/models/direction_details_info.dart';
import 'package:boride/models/directions.dart';
import 'package:boride/models/history.dart';
import 'package:boride/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static readCurrentOnlineUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(fAuth.currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        prefs.setString('my_name', userModelCurrentInfo!.name!);
        prefs.setString('my_email', userModelCurrentInfo!.email!);
        prefs.setString('my_phone', fAuth.currentUser!.phoneNumber!);
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng origionPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static sendNotificationToDriverNow(
      String deviceRegistrationToken, String userRideRequestId, context) async {
    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body": "Destination Address: \n$destinationAddress.",
      "title": "New Trip Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  static void getTripsKeys(context) {
    DatabaseReference tripsRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(fAuth.currentUser!.uid)
        .child("tripsHistory");
    tripsRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        Map values = snap.snapshot.value as Map;

        List<String> tripsIdKeys = [];
        values.forEach((key, value) {
          tripsIdKeys.add(key);
        });

        //update tripKeys to data provider
        Provider.of<AppInfo>(context, listen: false)
            .updateTripKeys(tripsIdKeys);

        getTripsData(context);
      }
    });
  }

  static void getTripsData(context) {
    var keys = Provider.of<AppInfo>(context, listen: false).tripsKeys;
    for (String eachKey in keys) {
      FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(eachKey)
          .once()
          .then((snaps) {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snaps.snapshot);

        if ((snaps.snapshot.value as Map)["status"] == "Completed") {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false)
              .updateTripsData(eachTripHistory);
        }
      });
    }
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

  static int calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo, String type) {
    // per km = ₦70,
    // per min = ₦10
    // base fare = ₦250

    double baseFare = 250;
    double distanceFare = (directionDetailsInfo.distance_value! / 1000) * 70;
    double timeFare = (directionDetailsInfo.duration_value! / 60) * 10;

    var totalFare = baseFare + distanceFare + timeFare;

    if (type == "corp") {
      totalFare = totalFare + 300;
      return (((totalFare - 0) ~/ 100) * 100).toInt();
    } else {
      if (totalFare <= 400) {
        totalFare = 500;
        return (((totalFare - 1) ~/ 100) * 100).toInt();
      }
      return (((totalFare - 0) ~/ 100) * 100).toInt();
    }
  }

  static calculateFareAmountFromOriginToDestinationDiscount(
      DirectionDetailsInfo directionDetailsInfo,
      String s,
      int percentageDiscount) {
    // per km = ₦70,
    // per min = ₦10
    // base fare = ₦250

    double baseFare = 250;
    double distanceFare = (directionDetailsInfo.distance_value! / 1000) * 70;
    double timeFare = (directionDetailsInfo.duration_value! / 60) * 10;
    var totalFare = baseFare + distanceFare + timeFare;

    if (s == "corp") {
      var nTotalFare = totalFare + 300;
      var dTotalFare = nTotalFare - ((percentageDiscount / 100) * totalFare);
      return (((dTotalFare - 50) ~/ 100) * 100).toInt();
    } else {
      var dTotalFare;
      dTotalFare = totalFare - ((percentageDiscount / 100) * totalFare);
      if (dTotalFare < 300) {
        dTotalFare = 300;
      }
      return (((dTotalFare - 0) ~/ 100) * 100).toInt();
    }
  }
}
