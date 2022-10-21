import 'package:boride/models/direction_details_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:boride/models/user_model.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
DirectionDetailsInfo? tripDirectionDetailsInfo;
