import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:boride/datamodels/address.dart';
import 'package:boride/datamodels/directiondetails.dart';
import 'package:boride/datamodels/nearbydriver.dart';
import 'package:boride/dataprovider/appdata.dart';
import 'package:boride/global/global.dart';
import 'package:boride/helper/firehelper.dart';
import 'package:boride/helper/helpermethods.dart';
import 'package:boride/screens/search_page.dart';
import 'package:boride/screens/select_nearest_active_driver_screen.dart';
import 'package:boride/widgets/brand_divider.dart';
import 'package:boride/widgets/my_drawer.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../brand_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _screenstate createState() => _screenstate();
}

class _screenstate extends State<MainPage> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kBorideHq = CameraPosition(
    target: LatLng(9.074329, 7.507098),
    zoom: 14,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  DirectionDetails? tripDirectionDetails;

  double bottomPaddingOfMap = 0;
  double searchSheetHeight = (Platform.isIOS) ? 275 : 255;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double requestingSheetHeight = 0; //(Platform.isAndroid) ? 195 : 220;

  List<LatLng> pLineCoOrdinatesList = [];
  List<NearbyDriver> onlineNearByAvailableDriversList = [];

  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail = "your Email";
  String appState = 'NORMAL';

  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  bool nearbyDriversKeysLoaded = false;
  bool isRequestingLocationDetails = false;

  BitmapDescriptor? activeNearbyIcon;

  DatabaseReference? rideRef;

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  setupPositionLocator() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    startGeoFireListener();

    await HelperMethod.findCordinateAddress(userCurrentPosition!, context);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    userName = userModelCurrentInfo!.fullName!;
    userEmail = userModelCurrentInfo!.email!;
  }

  @override
  void initState() {
    super.initState();
    setupPositionLocator();
    HelperMethod.getCurrentUserInfo();
  }

  void showDetailsSheet() async {
    setState(() {
      rideDetailsSheetHeight = (Platform.isAndroid) ? 245 : 255;
      openNavigationDrawer = true;

    });
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
            canvasColor: Colors.white,
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
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(10, 16),
            initialCameraPosition: _kBorideHq,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map

              setState(() {
                bottomPaddingOfMap = MediaQuery.of(context).size.height * 0.362;
              });

              setupPositionLocator();
            },
          ),

          ///Drawer button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: 14,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  setState(() {
                    rideDetailsSheetHeight = 0;
                    requestingSheetHeight = 0;
                    searchSheetHeight = (Platform.isAndroid) ? 255 : 275;
                    circlesSet.clear();
                    markersSet.clear();
                    polyLineSet.clear();
                    setupPositionLocator();
                    openNavigationDrawer = true;
                  });
                  //restart-refresh-minimize app progmatically
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  openNavigationDrawer ? Ionicons.menu : Ionicons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          /// Locate me
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.362,
            right: 14,
            child: GestureDetector(
              onTap: () async {
                setupPositionLocator();
                await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                LatLng latLngPosition = LatLng(userCurrentPosition!.latitude,
                    userCurrentPosition!.longitude);

                CameraPosition cameraPosition =
                    CameraPosition(target: latLngPosition, zoom: 17);

                newGoogleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));

                displayActiveDriversOnUsersMap();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Ionicons.locate_outline,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          ///Search sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: searchSheetHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("Where are you going?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Brand-Bold')),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          //go to search places screen
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const SearchPage()));

                          if (responseFromSearchScreen == "obtainedDropoff") {
                            setState(() {
                              openNavigationDrawer = false;
                            });

                            //draw routes - draw polyline
                            await drawPolyLineFromOriginToDestination();
                            showDetailsSheet();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 1,
                                    spreadRadius: 0.1,
                                    offset: Offset(0.1, 0.5))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.location_outline,
                            color: Colors.black54,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Drop location",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Brand-Bold",
                                  )),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                Provider.of<AppData>(context)
                                            .destinationAddress !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .destinationAddress!
                                        .placeName!
                                    : "Select a destination",
                                style: const TextStyle(
                                    fontFamily: "Brand-Bold",
                                    color: Colors.grey,
                                    fontSize: 13),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const BrandDivider(),
                      const SizedBox(
                        height: 14,
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: () {
                          if (Provider.of<AppData>(context, listen: false)
                                  .destinationAddress !=
                              null) {
                          } else {
                            showSnackBer("Please select destination location");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///Ride detail sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                height: rideDetailsSheetHeight,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: BrandColors.colorAccent1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/taxi.png',
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Taxi",
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: "Brand-Bold"),
                                  ),
                                  Text(
                                    tripDirectionDetailsInfo != null
                                        ? tripDirectionDetailsInfo!
                                            .duration_text!
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: BrandColors.colorTextLight),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                tripDirectionDetailsInfo != null
                                    ? '₦ ${HelperMethod.estimateFares(tripDirectionDetailsInfo!)}'
                                    : "",
                                style: const TextStyle(
                                    fontSize: 18, fontFamily: 'Brand-Bold'),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: const [
                            Icon(
                              FontAwesomeIcons.moneyBillAlt,
                              size: 18,
                              color: BrandColors.colorTextLight,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text("Cash"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: BrandColors.colorTextLight,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      ElevatedButton(
                        child: const Text(
                          "Request a Ride",
                        ),
                        onPressed: () {
                          setState(() {
                            appState = 'REQUESTING';
                            searchSheetHeight = 0;
                            rideDetailsSheetHeight = 0;
                            requestingSheetHeight = (Platform.isAndroid) ? 195 : 220;
                          });

                          createRideRequest();

                        },

                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///Request sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: requestingSheetHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                          waveDuration: const Duration(seconds: 6),
                          loadDuration: const Duration(minutes: 5),
                          text: 'Requesting a Ride...',
                          waveColor: BrandColors.colorTextDark,
                          boxBackgroundColor: Colors.white,
                          textStyle: const TextStyle(
                              color: BrandColors.colorText,
                              fontSize: 20.0,
                              fontFamily: 'Brand-Bold'),
                          boxHeight: 45.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          resetApp();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                width: 1.0,
                                color: BrandColors.colorLightGrayFair),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Cancel ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Trip Sheet


        ],
      ),
    );
  }

  createRideRequest() {
    //1. save the RideRequest Information

    var pickup =
        Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickupMap = {
      //"key" : value,
      "latitude": pickup!.latitude.toString(),
      "longitude": pickup.longitude.toString(),
    };

    Map destinaionMap = {
      //"key" : value,
      "latitude": destination!.latitude.toString(),
      "longitude": destination.longitude.toString(),
    };

    Map rideMap = {
      "create_at": DateTime.now().toString(),
      "rider_name": userModelCurrentInfo!.fullName,
      "rider_phone": userModelCurrentInfo!.phone,
      "pickup_address": pickup.placeName,
      "destination_Address": destination.placeName,
      "location": pickupMap,
      "destination": destinaionMap,
      "payment_method": "card",
      "driverId": "waiting"
    };

    databaseReference!.set(rideMap);

    onlineNearByAvailableDriversList = FireHelper.nearbyDriverList;
    searchNearestOnlineDrivers();
  }

  void showSnackBer(String title) {
    final snackBar = SnackBar(
        backgroundColor: BrandColors.colorGreen,
        duration: const Duration(seconds: 2),
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ));
    sKey.currentState!.showSnackBar(snackBar);
  }

  searchNearestOnlineDrivers() async {
    //no active driver available

    if (onlineNearByAvailableDriversList.isEmpty) {
      //cancel/delete the RideRequest Information
      rideRef!.remove();

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), () {
        SystemNavigator.pop();
      });
      return;
    } else {
      await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => SelectNearestActiveDriversScreen(
                  referenceRideRequest: rideRef!)));
    }

    //active driver available
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

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppData>(context, listen: false).pickupAddress;
    var destinationPosition =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var originLatLng =
        LatLng(originPosition!.latitude!, originPosition.longitude!);
    var destinationLatLng =
        LatLng(destinationPosition!.latitude!, destinationPosition.longitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...", status: '',
      ),
    );

    var thisDetail =
        await HelperMethod.getDirectionDetails(originLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(thisDetail!.e_points!);

    setState(() {
      tripDirectionDetailsInfo = thisDetail;
    });

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
        color: Colors.blueAccent,
        width: 7,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.squareCap,
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
          InfoWindow(title: originPosition.placeName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.placeName, snippet: "Destination"),
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

  startGeoFireListener() {
    Geofire.initialize("activeDrivers");

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
            NearbyDriver activeNearbyAvailableDriver = NearbyDriver();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.key = map['key'];
            FireHelper.nearbyDriverList.add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            NearbyDriver activeNearbyAvailableDriver = NearbyDriver();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.key = map['key'];
            FireHelper.updateNearbyLocation(activeNearbyAvailableDriver);
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
      Set<Marker> driversMarkerSet = <Marker>{};

      for (NearbyDriver eachDriver in FireHelper.nearbyDriverList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("driver" + eachDriver.key!),
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


  resetApp() {
    setState(() {
      pLineCoOrdinatesList.clear();
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 0;
      searchSheetHeight = (Platform.isAndroid) ? 275 : 300;
      openNavigationDrawer = true;


    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/car_android.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}
