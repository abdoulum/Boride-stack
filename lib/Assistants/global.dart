import 'package:firebase_auth/firebase_auth.dart';
import 'package:boride/models/direction_details_info.dart';
import 'package:boride/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAf6dyvU8:APA91bHQhfqDLvANOr4y962gN0a-aEDSBJT5ZAdMaE5VGSGHchUCB_2OsUF2iQkBlldFxsBAc-vkNInOJdkLOEif0fyGIIw3iSahKK0dY8-U7NKTAPlmY-o62Sv1eflvueyKkaNzWBPJ";
String userDropOffAddress = "";


String userHomeAddress = "";
String userHomeAddressId = "";
String userFavoriteAddress= "";
String userFavoriteAddressId= "";
String userFavoriteAddress2= "";
String userFavoriteAddress2Id= "";


String driverCarColor = "";
String driverCarPlate = "";
String driverCarModel = "";
String driverCarBrand = "";
String driverPhotoUrl = "";
String driverName="";
String driverPhone="";
String driverRId="";

double countRatingStars=0.0;
String titleStarsRating="";
String userRideRequestStatus="";
String state = "normal";
String driverRideStatus = "Driver is Coming";
int driverRequestTimeOut = 30;
DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");