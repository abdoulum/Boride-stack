import 'package:boride/authentication/login_page.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/global/global.dart';
import 'package:boride/helper/helpermethods.dart';
import 'package:boride/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RetryPage extends StatefulWidget {
  const RetryPage({Key? key}) : super(key: key);

  @override
  State<RetryPage> createState() => _RetryPageState();
}

class _RetryPageState extends State<RetryPage> {
  bool hasInternet = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  _verifyUser() async {
    if (fAuth.currentUser != null) {
      currentFirebaseUser = fAuth.currentUser;
      await Future.delayed(const Duration(milliseconds: 2500), () {});
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const MainPage()));
    } else {
      await Future.delayed(const Duration(milliseconds: 2500), () {});
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const LoginPage()));
    }
  }


  _checkInternetConnectivity() async {
    hasInternet = await InternetConnectionChecker().hasConnection;

    if (hasInternet == true) {
      HelperMethod.getCurrentUserInfo();
      _verifyUser();
    } else {
      await Future.delayed(const Duration(milliseconds: 1000), () {});
      showSnackBer("Check your internet connection");
    }
  }

  void showSnackBer(String title) {
    final snackBar = SnackBar(
      backgroundColor: BrandColors.colorPink,
      duration: const Duration(seconds: 2),
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No internet connection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,fontFamily: "Brand-Bold"),),
              const SizedBox(height: 20,),
              RaisedButton(
                onPressed: () { _checkInternetConnectivity();
                },
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                color: Colors.black87,
                textColor: BrandColors.colorLightGray,
                child: const SizedBox(
                  height: 50,
                  width: 140,
                  child: Center(
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Colors.white,fontSize: 18, fontFamily: 'Brand-Bold'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
