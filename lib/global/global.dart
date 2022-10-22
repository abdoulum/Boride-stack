import 'package:boride/datamodels/directiondetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:boride/datamodels/user.dart';
import 'package:firebase_database/firebase_database.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetails? tripDirectionDetailsInfo;
User? currentUserInfo;
DatabaseReference? databaseReference;
