import 'package:firebase_auth/firebase_auth.dart';
import 'package:boride/models/direction_details_info.dart';
import 'package:boride/models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAf6dyvU8:APA91bHQhfqDLvANOr4y962gN0a-aEDSBJT5ZAdMaE5VGSGHchUCB_2OsUF2iQkBlldFxsBAc-vkNInOJdkLOEif0fyGIIw3iSahKK0dY8-U7NKTAPlmY-o62Sv1eflvueyKkaNzWBPJ";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars=0.0;
String titleStarsRating="";