import 'dart:async';
import 'dart:io';

import 'package:boride/assistants/app_info.dart';
import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/assistants/geofire_assistant.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/assistants/map_key.dart';
import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/mainScreens/rate_driver_screen.dart';
import 'package:boride/mainScreens/search_places_screen.dart';
import 'package:boride/models/active_nearby_available_drivers.dart';
import 'package:boride/models/directions.dart';
import 'package:boride/widgets/my_drawer.dart';
import 'package:boride/widgets/noDriverAvailableDialog.dart';
import 'package:boride/widgets/pay_fare_amount_dialog.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
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
  bool hasDiscount = false;

  double searchLocationContainerHeight = 0;
  double requestingRideContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double rideDetailsContainerHeight = 0;
  double safetyContainerHeight = 0;
  double bottomPaddingOfMap = 0;
  double locateUiPadding = Platform.isAndroid ? 270 : 270;

  double amountSize = 20;

  Position? userCurrentPosition;
  BitmapDescriptor? activeNearbyIcon;
  DatabaseReference? referenceRideRequest;
  LocationPermission? _locationPermission;
  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String carRideType = "";
  String fareAmount = "";
  String userName = "your Name";
  String userEmail = "your Email";
  String selectedPaymentMethod = "";
  int? percentageDiscount;

  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  List<LatLng> pLineCoOrdinatesList = [];

  var geoLocator = Geolocator();
  final paymentMethodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AssistantMethods.getTripsKeys(context);
    checkIfLocationPermissionAllowed();
    checkPromo();
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
          child: MyDrawer(),
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
                locateUiPadding = Platform.isAndroid
                    ? MediaQuery.of(context).size.height * 0.36
                    : MediaQuery.of(context).size.height * 0.32;
                bottomPaddingOfMap = Platform.isAndroid
                    ? MediaQuery.of(context).size.height * 0.36
                    : MediaQuery.of(context).size.height * 0.32;
                searchLocationContainerHeight = Platform.isAndroid
                    ? MediaQuery.of(context).size.height * 0.34
                    : MediaQuery.of(context).size.height * 0.30;
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
                  resetApp();
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
                    color: Colors.indigo,
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
              onTap: () async {
                Position cPosition = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                userCurrentPosition = cPosition;

                LatLng latLngPosition = LatLng(userCurrentPosition!.latitude,
                    userCurrentPosition!.longitude);

                CameraPosition cameraPosition =
                    CameraPosition(target: latLngPosition, zoom: 16);

                newGoogleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));

                AssistantMethods.searchAddressForGeographicCoOrdinates(
                    userCurrentPosition!, context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: .5,
                      spreadRadius: 0.4,
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
                  child: Icon(Ionicons.locate, color: Colors.indigo),
                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            left: 1.0,
            right: 1.0,
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
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.maximize_rounded,
                          size: 25,
                        ),
                      ),
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
                      const SizedBox(height: 6.0),
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
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(7.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.transparent,
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
                                  color: Colors.indigo,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Search Drop Off",
                                  style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final homeAddressId =
                                      prefs.getString('my_home_address_id') ??
                                          '';
                                  getPlaceDirectionDetails(homeAddressId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Ionicons.home_outline,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              const Text(
                                "Home",
                                style: TextStyle(
                                    fontFamily: "Brand-Regular", fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final favAddressId = prefs.getString(
                                          'my_favorite_address_id') ??
                                      '';

                                  getPlaceDirectionDetails(favAddressId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Ionicons.star_outline,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              const Text(
                                "Favorite 1",
                                style: TextStyle(
                                    fontFamily: "Brand-Regular", fontSize: 12),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final favAddressId = prefs.getString(
                                          'my_favorite_address2_id') ??
                                      '';

                                  getPlaceDirectionDetails(favAddressId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Ionicons.star_outline,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              const Text(
                                "Favorite 2",
                                style: TextStyle(
                                    fontFamily: "Brand-Regular", fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.9,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      //boride-go
                      GestureDetector(
                        onTap: () {
                          if (selectedPaymentMethod.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select a payment method");
                          } else {
                            setState(() {
                              state = "requesting";
                              carRideType = "boride-go";
                            });
                            displayRequestRideContainer();
                            onlineNearByAvailableDriversList = GeoFireAssistant
                                .activeNearbyAvailableDriversList;
                            searchNearestDriver();
                          }
                        },
                        child: Container(
                          color: BrandColors.Accent2,
                          width: MediaQuery.of(context).size.width * 1,
                          height: 60,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/uber-go.png",
                                  height: 60.0,
                                  width: 80.0,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Boride-Go",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Brand-Bold",
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
                                        fontFamily: "Brand-Regular",
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ((tripDirectionDetailsInfo != null)
                                          ? '\$${AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!, "go")}'
                                          : ''),
                                      style: TextStyle(
                                        fontSize: amountSize,
                                        fontFamily: "Brand-Bold",
                                      ),
                                    ),
                                    hasDiscount ? Text(
                                      ((tripDirectionDetailsInfo != null)
                                          ? '\$${AssistantMethods.calculateFareAmountFromOriginToDestinationDiscount(tripDirectionDetailsInfo!, "go", percentageDiscount!)}'
                                          : ''),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Brand-Bold",
                                      ),
                                    ) : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //boride-corporate
                      GestureDetector(
                        onTap: () {
                          if (selectedPaymentMethod.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please select a payment method");
                          } else {
                            setState(() {
                              state = "requesting";
                              carRideType = "boride-corporate";
                            });
                            displayRequestRideContainer();
                            onlineNearByAvailableDriversList = GeoFireAssistant
                                .activeNearbyAvailableDriversList;
                            searchNearestDriver();
                          }
                        },
                        child: Container(
                          color: BrandColors.Accent2,
                          width: MediaQuery.of(context).size.width * 1,
                          height: 60,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/uber-x.png",
                                  height: 60.0,
                                  width: 80.0,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Boride-Corporate",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Brand-Bold",
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
                                        fontFamily: "Brand-Regular",
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ((tripDirectionDetailsInfo != null)
                                          ? '\$${AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!, "corp")}'
                                          : ''),
                                      style: TextStyle(
                                        fontSize: amountSize,
                                        fontFamily: "Brand-Bold",
                                      ),
                                    ),
                                    hasDiscount ? Text(
                                      ((tripDirectionDetailsInfo != null)
                                          ? '\$${AssistantMethods.calculateFareAmountFromOriginToDestinationDiscount(tripDirectionDetailsInfo!, "corp", percentageDiscount!)}'
                                          : ''),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Brand-Bold",
                                      ),
                                    ) : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Divider(
                        color: Colors.black,
                        height: 10,
                        thickness: 0.2,
                      ),

                      hasDiscount ? const Text("Promo applied", style: TextStyle(
                          fontFamily: "Brand-bold",
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),) : Container(),

                      GestureDetector(
                        onTap: _openBottomSheet,
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          child: Row(
                            children: [
                              const Text(
                                "Select Payment Method: ",
                                style: TextStyle(
                                    fontFamily: "Brand-Bold",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                selectedPaymentMethod,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Brand-Regular",
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 25.0,
                              ),
                            ],
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 0.9,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: requestingRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          "Searching ...",
                          style: TextStyle(
                              fontSize: 25, fontFamily: "Brand-Regular"),
                        ))),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 2.0, color: Colors.grey),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 23.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Cancel Ride",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0),
                      ),
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
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 0.9,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: assignedDriverInfoContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          driverRideStatus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Bold",
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 15,
                      thickness: 0.2,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: "Brand-Regular"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "$driverCarColor  $driverCarModel,   $driverCarPlate",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Brand-Regular"),
                            ),
                          ],
                        ),
                        const Spacer(),
                        userRideRequestStatus != "onride"
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 245, 247),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 24.0,
                                      child: IconButton(
                                        icon: const Icon(Ionicons.call),
                                        color: Colors.green,
                                        onPressed: () {
                                          launch(('tel://$driverPhone'));
                                        },
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "Call driver",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Brand-Regular"),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      thickness: 0.2,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 243, 245, 247),
                                  borderRadius: BorderRadius.circular(30)),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 28.0,
                                child: Image.asset(
                                  "images/uber-x.png",
                                  width: 40,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Driver",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "Brand-Regular"),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 28.0,
                                child: IconButton(
                                  icon: const Icon(Ionicons.shield),
                                  color: Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      safetyContainerHeight =
                                          MediaQuery.of(context).size.height *
                                              0.31;
                                      bottomPaddingOfMap =
                                          MediaQuery.of(context).size.height *
                                              0.33;
                                      locateUiPadding =
                                          MediaQuery.of(context).size.height *
                                              0.33;
                                      rideDetailsContainerHeight = 0;
                                      assignedDriverInfoContainerHeight = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Safety",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "Brand-Regular"),
                            )
                          ],
                        ),
                        userRideRequestStatus != "onride"
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 245, 247),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 28.0,
                                      child: IconButton(
                                        icon: const Icon(Ionicons.car_sport),
                                        color: Colors.red,
                                        onPressed: () {
                                          if (userRideRequestStatus !=
                                              "onride") {
                                            cancelRide();
                                            cancelRideRequest();
                                            resetApp();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Brand-Regular"),
                                  )
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          //safety ui
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 0.9,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: safetyContainerHeight,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 10.0),
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Safety Options",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black54,
                                  fontFamily: "Brand-Bold"),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    safetyContainerHeight = 0;
                                    assignedDriverInfoContainerHeight = Platform
                                            .isAndroid
                                        ? MediaQuery.of(context).size.height *
                                            0.35
                                        : MediaQuery.of(context).size.height *
                                            0.32;
                                    bottomPaddingOfMap = Platform.isAndroid
                                        ? MediaQuery.of(context).size.height *
                                            0.37
                                        : MediaQuery.of(context).size.height *
                                            0.30;
                                    locateUiPadding = Platform.isAndroid
                                        ? MediaQuery.of(context).size.height *
                                            0.37
                                        : MediaQuery.of(context).size.height *
                                            0.30;
                                  });
                                },
                                icon: const Icon(
                                  Ionicons.close_circle_outline,
                                  size: 25,
                                  color: Colors.black54,
                                ))
                          ],
                        ),
                        const Text(
                          "These safety options are here to help you in the case of emergency situations",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontFamily: "Brand-Regular"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Share.share(
                                'https://www.google.com/maps/search/?api=1&query=${userCurrentPosition!.latitude},${userCurrentPosition!.longitude}');
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.antenna_radiowaves_left_right,
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      "Share ride details",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Brand-Regular",
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.0,
                                    ),
                                    Text(
                                      "Share your live location and car info",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        fontSize: 12.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Ionicons.radio,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 14.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  "Emergency assist",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  "Call local authority",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 12.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ])),
            ),
          ),
        ],
      ),
    );
  }

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

    AssistantMethods.searchAddressForGeographicCoOrdinates(
        userCurrentPosition!, context);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();
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
      "p_discount" : 10,
      "payment_method": selectedPaymentMethod,
      "ride_type": carRideType,
      "time": DateTime.now().toString(),
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      setState(() {
        driverCarColor =
            (eventSnap.snapshot.value as dynamic)["car_color"].toString();
        driverCarPlate =
            (eventSnap.snapshot.value as dynamic)["car_number"].toString();
        driverCarModel =
            (eventSnap.snapshot.value as dynamic)["car_model"].toString();
      });

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
      if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
        setState(() {
          driverRId = (eventSnap.snapshot.value as Map)["driverId"].toString();
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
            updateReachingTimeToUserDropOffLocation(
                driverCurrentPositionLatLng);
          });
        }

        //status = ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            String fareAmount =
                (eventSnap.snapshot.value as Map)["fareAmount"].toString();

            var response = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext c) => PayFareAmountDialog(
                fareAmount: fareAmount,
                paymentMtd: selectedPaymentMethod,
              ),
            );

            DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
                .ref()
                .child("users")
                .child(fAuth.currentUser!.uid)
                .child("tripsHistory");

            tripsHistoryRef.child(referenceRideRequest!.key!).set(true);

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
            } else if (response == "CardPaymentSuccessful") {
              Fluttertoast.showToast(msg: "Card Payment Successful");
              resetApp();
            } else {
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
            "Driver is Coming: ${directionDetailsInfo.duration_text}";
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

      return;
    }

    //active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //assign/SET rideRequestId to newRideStatus in
    // Drivers Parent node for that specific chosen driver
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
      } else {}
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

  showUIForAssignedDriverInfo() {
    setState(() {
      requestingRideContainerHeight =
          0; //Platform.isAndroid ? MediaQuery.of(context).size.height * 0.37 : MediaQuery.of(context).size.height * 0.32;

      searchLocationContainerHeight =
          0; //Platform.isAndroid ? MediaQuery.of(context).size.height * 0.37 : MediaQuery.of(context).size.height * 0.32;

      bottomPaddingOfMap = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.37
          : MediaQuery.of(context).size.height * 0.30;
      locateUiPadding = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.37
          : MediaQuery.of(context).size.height * 0.30;
      assignedDriverInfoContainerHeight = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.35
          : MediaQuery.of(context).size.height * 0.32;
    });
  }

  void displayRideDetailsContainer() async {
    await drawPolyLineFromOriginToDestination();
    setState(() {
      searchLocationContainerHeight = 0;

      rideDetailsContainerHeight = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.34
          : MediaQuery.of(context).size.height * 0.29;
      bottomPaddingOfMap = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.35
          : MediaQuery.of(context).size.height * 0.30;
      locateUiPadding = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.36
          : MediaQuery.of(context).size.height * 0.30;
      openNavigationDrawer = false;
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      rideDetailsContainerHeight = 0;
      searchLocationContainerHeight = 0;

      requestingRideContainerHeight = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.30
          : MediaQuery.of(context).size.height * 0.30;
      bottomPaddingOfMap = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.33
          : MediaQuery.of(context).size.height * 0.30;
      locateUiPadding = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.33
          : MediaQuery.of(context).size.height * 0.30;
      openNavigationDrawer = true;
    });

    saveRideRequestInformation();
  }

  getPlaceDirectionDetails(String? placeId) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Up Dropoff...",
      ),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });
    }

    displayRideDetailsContainer();
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

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPolyLinePointsResultList) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("PolylineID"),
        color: const Color.fromARGB(255, 95, 109, 237),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        width: 4,
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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: BrandColors.colorGreen,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.green,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: BrandColors.colorAccentPurple,
      radius: 12,
      strokeWidth: 3,
      strokeColor: BrandColors.colorAccentPurple,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    GeoFireAssistant.activeNearbyAvailableDriversList.clear();
    onlineNearByAvailableDriversList.clear();

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
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

      Set<Marker> driversMarkerSet = <Marker>{};

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver${eachDriver.driverId!}"),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: AssistantMethods.generateRandomNumber(360),
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
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
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
      if (snap.snapshot.value != null) {
        String carType = snap.snapshot.value.toString();
        if (carType == carRideType) {
          notifyDriver(driver);
          onlineNearByAvailableDriversList.removeAt(0);
        } else {
          Fluttertoast.showToast(msg: "$carRideType not available.");
          cancelRideRequest();
          displayRideDetailsContainer();
          requestingRideContainerHeight = 0;
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

      rideDetailsContainerHeight = 0;
      requestingRideContainerHeight = 0;
      assignedDriverInfoContainerHeight = 0;

      locateUiPadding = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.36
          : MediaQuery.of(context).size.height * 0.32;
      bottomPaddingOfMap = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.36
          : MediaQuery.of(context).size.height * 0.32;
      searchLocationContainerHeight = Platform.isAndroid
          ? MediaQuery.of(context).size.height * 0.34
          : MediaQuery.of(context).size.height * 0.30;

      selectedPaymentMethod == "";
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoOrdinatesList.clear();

      userRideRequestStatus = "";
      driverName = "";
      driverPhone = "";
      driverCarColor = "";
      driverCarModel = "";
      driverCarPlate = "";
      driverRideStatus = "Driver is Coming";
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
      Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.driverId!).child("newRide").set("cancelled");
          driversRef.child(driver.driverId!).child("newRide").onDisconnect();
          driverRequestTimeOut = 10;
          timer.cancel();
        }

        driverRequestTimeOut--;

        driversRef
            .child(driver.driverId!)
            .child("newRide")
            .onValue
            .listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.driverId!).child("newRide").onDisconnect();
            timer.cancel();
            driverRequestTimeOut = 10;
          }
        });
        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.driverId!).child("newRide").set("timeout");
          driversRef.child(driver.driverId!).child("newRide").onDisconnect();
          driverRequestTimeOut = 10;
          timer.cancel();

          searchNearestDriver();
        }
      });
    });
  }

  cancelRide() {
    FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(referenceRideRequest!.key!)
        .child("status")
        .set("cancelled");

    setState(() {
      userRideRequestStatus == "cancelled";
    });
    Timer(const Duration(seconds: 3), () async {
      cancelRideRequest();
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

  checkPromo() {
    DatabaseReference promoRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(fAuth.currentUser!.uid)
        .child("promo");
    promoRef.child("percentageDiscount").once().then((snap) {
      if (snap.snapshot.value != null) {
        setState(() async {
          percentageDiscount = snap.snapshot.value as int;
          hasDiscount = true;
          amountSize = 14;
        });
      }
    });
  }

  calculateDiscount() {

  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog());
  }

  _handleCurrencyTap(String paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
      paymentMethodController.text = paymentMethod;
    });
    Navigator.pop(context);
  }
}
