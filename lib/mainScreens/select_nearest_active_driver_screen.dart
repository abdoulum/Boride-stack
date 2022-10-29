import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({Key? key, this.referenceRideRequest})
      : super(key: key);

  @override
  _SelectNearestActiveDriversScreenState createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";

  getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionDetailsInfo != null) {
      if (dList[index]["car_details"]["type"].toString() == "bike") {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) /
                    1)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() ==
          "uber-x") //means executive type of car - more comfortable pro level
      {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                        tripDirectionDetailsInfo!) *
                    1)
                .toStringAsFixed(1);
      }
      if (dList[index]["car_details"]["type"].toString() ==
          "uber-go") // non - executive car - comfortable
      {
        fareAmount =
            (AssistantMethods.calculateFareAmountFromOriginToDestination(
                    tripDirectionDetailsInfo!))
                .toStringAsExponential();
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading:
        GestureDetector(
          onTap: () async {
            widget.referenceRideRequest!.remove();
            dList.clear();
            await Fluttertoast.showToast(msg: "Ride Request Cancelled");
            Navigator.pop(context);
          },
          child: const Icon(
            Ionicons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverChosen");
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: BrandColors.colorPrimary,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" +
                        dList[index]["car_details"]["type"].toString() +
                        ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Brand-Bold",
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: "Brand-Bold",
                        color: Colors.black,
                      ),
                    ),
                    SmoothStarRating(
                      rating: dList[index]["ratings"] == null
                          ? 0.0
                          : double.parse(dList[index]["ratings"]),
                      color: Colors.black,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$ " + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        fontFamily: "Brand-Bold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.duration_text!
                          : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,

                          fontFamily: "Brand-Bold",
                          color: Colors.black,
                          fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.distance_text!
                          : "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brand-Bold",
                          color: Colors.black54,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
