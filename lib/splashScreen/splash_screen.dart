import 'package:boride/authentication/login_page.dart';
import 'package:boride/global/global.dart';
import 'package:boride/helper/helpermethods.dart';
import 'package:boride/screens/main_page.dart';
import 'package:boride/splashScreen/retry_page.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool hasInternet = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  void showSnackBer(String title) {
    final snackBar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    HelperMethod.getCurrentUserInfo();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    _checkInternetConnectivity();
  }

  _checkInternetConnectivity() async {
    hasInternet = await InternetConnectionChecker().hasConnection;

    if (hasInternet == true) {
      HelperMethod.getCurrentUserInfo();
      _verifyUser();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const RetryPage()));

    }
  }

  _verifyUser() {
    if (fAuth.currentUser != null) {
      currentFirebaseUser = fAuth.currentUser;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const MainPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const LoginPage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            "Boride",
            style: TextStyle(
                fontSize: 70, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
