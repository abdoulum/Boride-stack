import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/assistants/geofire_assistant.dart';
import 'package:boride/global/global.dart';
import 'package:boride/infoHandler/app_info.dart';
import 'package:boride/mainScreens/rate_driver_screen.dart';
import 'package:boride/mainScreens/search_places_screen.dart';
import 'package:boride/models/active_nearby_available_drivers.dart';
import 'package:boride/widgets/my_drawer.dart';
import 'package:boride/widgets/noDriverAvailableDialog.dart';
import 'package:boride/widgets/pay_fare_amount_dialog.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kBorideHq = CameraPosition(
    target: LatLng(9.074329, 7.507098),
    zoom: 16,
  );


  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();


  bool requestPositionInfo = true;
  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  bool isTestMode = true;


  double searchLocationContainerHeight = 260;
  double requestingRideContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double rideDetailsContainerHeight = 0;
  double bottomPaddingOfMap = 0;
  double locateUiPadding = 270;

  Position? userCurrentPosition;
  BitmapDescriptor? activeNearbyIcon;
  DatabaseReference? referenceRideRequest;
  LocationPermission? _locationPermission;
  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String carRideType="";
  String fareAmount = "";
  String userName = "your Name";
  String userEmail = "your Email";
  String selectedPaymentMethod = "";


  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  List<LatLng> pLineCoOrdinatesList = [];


  var geoLocator = Geolocator();
  final paymentMethodController = TextEditingController();


  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  saveRideRequestInformation() {
    //1. save the RideRequest Information
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("Ride Request").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key": value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key": value,
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "pickup": originLocationMap,
      "dropoff": destinationLocationMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userModelCurrentInfo!.name,
      "rider_phone": userModelCurrentInfo!.phone,
      "pickup_address": originLocation.locationName,
      "dropoff_address": destinationLocation.locationName,
      "driver_id": "waiting",
      "payment_method": selectedPaymentMethod,
      "ride_type": carRideType,
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted
        if (userRideRequestStatus == "accepted") {
          showUIForAssignedDriverInfo();
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }

        //status = arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        //status = onride
        if (userRideRequestStatus == "onride") {
          setState(() {
            driverRideStatus =
                "Driver is Coming :: ${tripDirectionDetailsInfo!.duration_text}";
          });
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        //status = ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            String fareAmount = (eventSnap.snapshot.value as Map)["fareAmount"].toString();

            var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext c) => PayFareAmountDialog(
                fareAmount: fareAmount, paymentMtd: selectedPaymentMethod,
              ),
            );

            if (response == "cashPayed") {
              //user can rate the driver now
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId =
                    (eventSnap.snapshot.value as Map)["driverId"].toString();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => RateDriverScreen(
                              assignedDriverId: assignedDriverId,
                            )));

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();
                resetApp();
              }
            } else if(response == "CardPaymentSuccessful") {
              Fluttertoast.showToast(msg: "Card Payment Successful");
              resetApp();
            }
            else {
              Fluttertoast.showToast(msg: "Error, check payment method");
            }
          }
        }
      }
    });

    onlineNearByAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus =
            "Driver is Coming :: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation.locationLongitude!);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus =
            " Trip started: ${directionDetailsInfo.duration_text}";
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async {
    //no active driver available
    if (onlineNearByAvailableDriversList.isEmpty) {
      //cancel/delete the RideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      return;
    }

    //active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    // var response = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SelectNearestActiveDriversScreen(referenceRideRequest: referenceRideRequest)));

    // if(response == "driverChoosed")
    // {
    //   FirebaseDatabase.instance.ref()
    //       .child("drivers")
    //       .child(chosenDriverId!)
    //       .once()
    //       .then((snap)
    //   {
    //     if(snap.snapshot.value != null)
    //     {
    //       //send notification to that specific driver
    //       sendNotificationToDriverNow(chosenDriverId!);
    //
    //       //Display Waiting Response UI from a Driver
    //       showWaitingResponseFromDriverUI();
    //
    //       //Response from a Driver
    //       FirebaseDatabase.instance.ref()
    //           .child("drivers")
    //           .child(chosenDriverId!)
    //           .child("newRide")
    //           .onValue.listen((eventSnapshot)
    //       {
    //         //1. driver has cancel the rideRequest :: Push Notification
    //         // (newRideStatus = idle)
    //         if(eventSnapshot.snapshot.value == "idle")
    //         {
    //           Fluttertoast.showToast(msg: "The driver has cancelled your request. Please choose another driver.");
    //
    //           Future.delayed(const Duration(milliseconds: 3000), ()
    //           {
    //             Fluttertoast.showToast(msg: "Please Restart App Now.");
    //
    //           });
    //         }
    //
    //         //2. driver has accept the rideRequest :: Push Notification
    //         // (newRideStatus = accepted)
    //         if(eventSnapshot.snapshot.value == "accepted")
    //         {
    //           //design and display ui for displaying assigned driver information
    //           showUIForAssignedDriverInfo();
    //         }
    //       });
    //     }
    //     else
    //     {
    //       Fluttertoast.showToast(msg: "This driver do not exist. Try again.");
    //     }
    //   });
    // }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      requestingRideContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 260;
    });
  }

  showWaitingResponseFromDriverUI() {
    setState(() {
      searchLocationContainerHeight = 0;
      requestingRideContainerHeight = 240;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //assign/SET rideRequestId to newRideStatus in
    // Drivers Parent node for that specific choosen driver
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRide")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  void displayRideDetailsContainer() async {
    await drawPolyLineFromOriginToDestination();

    setState(() {
      searchLocationContainerHeight = 0;
      rideDetailsContainerHeight = 200;
      bottomPaddingOfMap = 210;
      locateUiPadding = 210;
      openNavigationDrawer = false;
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestingRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 260.0;
      locateUiPadding = 260;
      openNavigationDrawer = true;
    });

    saveRideRequestInformation();
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();

    return Scaffold(
      key: sKey,
      drawer: SizedBox(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _kBorideHq,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 270;
              });

              locateUserPosition();
            },
          ),

          //Drawer Button UI
          Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //restart-refresh-minimize app progmatically

                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0,
                        0,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23.0,
                  child: Icon(
                    openNavigationDrawer ? Icons.menu : Icons.close,
                  ),
                ),
              ),
            ),
          ),

          //Locate Me UI
          Positioned(
            right: 15,
            bottom: locateUiPadding,
            child: GestureDetector(
              onTap: () {
                locateUserPosition();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0,
                        0,
                      ),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25.0,
                  child: Icon(Ionicons.locate, color: Colors.blue),
                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                      spreadRadius: 0.9,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      const Text(
                        "Hi there,",
                        style: TextStyle(
                            fontSize: 12.0, fontFamily: "Brand-Regular"),
                      ),
                      const Text(
                        "Where to?",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPlacesScreen()));

                          if (res == "obtainedDropoff") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 2.0,
                                spreadRadius: 0.2,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Search Drop Off",
                                  style: TextStyle(fontFamily: "Brand-Regular"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Home address",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    fontFamily: "Brand-Regular"),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? "${Provider.of<AppInfo>(context)
                                            .userPickUpLocation!
                                            .locationName!} ..."
                                    : "Add Home",
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: "Brand-Regular"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Work address",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    fontFamily: "Brand-Regular"),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Paradime inc, Central city, Abuja",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Brand-Regular"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Ride Details UI
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      //uber-go ride
                      GestureDetector(
                        onTap: () {
                          if (selectedPaymentMethod.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select a payment method");
                          } else {
                            Fluttertoast.showToast(msg: "searching Uber-Go...");

                            setState(() {
                              state = "requesting";
                              carRideType = "uber-go";
                            });
                            displayRequestRideContainer();
                            onlineNearByAvailableDriversList = GeoFireAssistant
                                .activeNearbyAvailableDriversList;
                            searchNearestDriver();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/uber-go.png",
                                  height: 70.0,
                                  width: 80.0,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Boride-Go",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand Bold",
                                      ),
                                    ),
                                    Text(
                                      ((tripDirectionDetailsInfo != null)
                                          ? tripDirectionDetailsInfo!
                                              .distance_text!
                                          : ''),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetailsInfo != null)
                                      ? '\$${AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)}'
                                      : ''),
                                  style: const TextStyle(
                                    fontFamily: "Brand Bold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        height: 2.0,
                        thickness: 2.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      GestureDetector(
                        onTap: _openBottomSheet,
                        child: Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.moneyCheckAlt,
                                  size: 18.0,
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  selectedPaymentMethod != null
                                      ? selectedPaymentMethod
                                      : "Select Payment Method",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Waiting UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: requestingRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12.0,),

                    SizedBox(
                      width: double.infinity,
                      child: ColorizeAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: const [
                            "Requesting a Ride...",
                            "Please wait...",
                          ],
                          textStyle: const TextStyle(
                              fontSize: 35.0,
                              fontFamily: "Signatra"
                          ),
                          colors: const [
                            Colors.green,
                            Colors.purple,
                            Colors.pink,
                            Colors.blue,
                            Colors.yellow,
                            Colors.red,
                          ],
                          textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 22.0,),

                    GestureDetector(
                      onTap: ()
                      {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0, color: Colors.grey),
                        ),
                        child: const Icon(Icons.close, size: 26.0,),
                      ),
                    ),

                    const SizedBox(height: 10.0,),

                    Container(
                      width: double.infinity,
                      child: const Text("Cancel Ride", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //ui for displaying assigned driver information
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: assignedDriverInfoContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6.0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          driverRideStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Bold",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 18.0,
                    ),

                    const Divider(
                      height: 2.0,
                      thickness: 2.0,
                    ),

                    const SizedBox(
                      height: 18.0,
                    ),

                    Text(
                      driverCarDetails,
                      style: const TextStyle(
                          color: Colors.grey, fontFamily: "Brand-Bold"),
                    ),

                    Text(
                      driverName,
                      style: const TextStyle(
                          fontSize: 20.0, fontFamily: "Brand-Bold"),
                    ),

                    const SizedBox(
                      height: 22.0,
                    ),

                    const Divider(
                      height: 2.0,
                      thickness: 2.0,
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),


                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              launch(('tel://$driverPhone'));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 3.0,
                                    spreadRadius: 0.2,
                                    offset: Offset(
                                      0.7,
                                      0.2,
                                    ),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25.0,
                                child: Icon(Ionicons.call, color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Call driver",
                            style: TextStyle(
                                fontFamily: "Brand-Regular", fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.purpleAccent,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver${eachDriver.driverId!}"),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  void cancelRideRequest() {
    referenceRideRequest!.remove();
    setState(() {
      state = "normal";
    });
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog());
  }

  void searchNearestDriver() {
    if (onlineNearByAvailableDriversList.isEmpty) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = onlineNearByAvailableDriversList[0];

    driversRef
        .child(driver.driverId!)
        .child("car_details")
        .child("type")
        .once()
        .then((snap) async {
      if (await snap.snapshot.value != null) {
        String carType = snap.snapshot.value.toString();
        if (carType == carRideType) {
          notifyDriver(driver);
          onlineNearByAvailableDriversList.removeAt(0);
        } else {
          Fluttertoast.showToast(
              msg: "$carRideType drivers not available. Try again.");
          resetApp();
        }
      } else {
        Fluttertoast.showToast(msg: "No car found. Try again.");
        resetApp();
      }
    });
  }

  resetApp() {
    setState(() {
      openNavigationDrawer = true;
      searchLocationContainerHeight = 260.0;
      rideDetailsContainerHeight = 0;
      requestingRideContainerHeight = 0;
      bottomPaddingOfMap = 270.0;
      locateUiPadding = 270;

      selectedPaymentMethod == "";
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoOrdinatesList.clear();

      userRideRequestStatus = "";
      driverName = "";
      driverPhone = "";
      driverCarDetails = "";
      driverRideStatus = "Driver is Coming";
      assignedDriverInfoContainerHeight = 0.0;
    });

    locateUserPosition();
  }

  void notifyDriver(ActiveNearbyAvailableDrivers driver) {
    driversRef
        .child(driver.driverId!)
        .child("newRide")
        .set(referenceRideRequest!.key);

    driversRef.child(driver.driverId!).child("token").once().then((snap) {
      if (snap.snapshot.value != null) {
        String token = snap.snapshot.value.toString();
        AssistantMethods.sendNotificationToDriverNow(
            token, referenceRideRequest!.key!, context);
      } else {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.driverId!).child("newRide").set("cancelled");
          driversRef.child(driver.driverId!).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();
        }

        driverRequestTimeOut = driverRequestTimeOut - 1;

        driversRef
            .child(driver.driverId!)
            .child("newRide")
            .onValue
            .listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.driverId!).child("newRide").onDisconnect();
            driverRequestTimeOut = 40;
            timer.cancel();
          }
        });

        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.driverId!).child("newRide").set("timeout");
          driversRef.child(driver.driverId!).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();

          searchNearestDriver();
        }
      });
    });
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _getPaymentMethod();
        });
  }

  Widget _getPaymentMethod() {
    final paymentMethods = ["Card", "Cash"];
    return Container(
      height: 140,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: paymentMethods
            .map((paymentMethod) => ListTile(
                  onTap: () => {_handleCurrencyTap(paymentMethod)},
                  title: Column(
                    children: [
                      Text(
                        paymentMethod,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Brand-Regular"),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
      paymentMethodController.text = paymentMethod;
    });
    Navigator.pop(context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
