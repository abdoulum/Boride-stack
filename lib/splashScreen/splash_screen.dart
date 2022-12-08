import 'dart:async';

import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/authentication/login_screen.dart';
import 'package:boride/mainScreens/main_screen.dart';
import 'package:boride/splashScreen/retry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  MySplashScreenState createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    Timer(const Duration(seconds: 3), () {
      checkInternetAccess();

      if (fAuth.currentUser != null) {
        AssistantMethods.readCurrentOnlineUserInfo();
        AssistantMethods.getTripsKeys(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const MainScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  checkInternetAccess() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (!hasInternet) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const RetryPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: const [0.1, 0.5, 0.7, 0.9],
              colors: [
                Colors.indigo.shade500,
                Colors.indigo.shade600,
                Colors.indigo.shade800,
                Colors.indigo.shade900,
              ],
            ),
          ),
          child: Center(
            child: Image.asset(
              "images/boride_logo.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
