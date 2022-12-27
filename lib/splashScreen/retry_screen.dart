import 'dart:async';

import 'package:boride/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RetryPage extends StatefulWidget {
  const RetryPage({Key? key}) : super(key: key);

  @override
  State<RetryPage> createState() => _RetryPageState();
}

class _RetryPageState extends State<RetryPage> {
  @override
  void initState() {
    super.initState();

    Fluttertoast.showToast(
      msg: "No Internet Connection",
      backgroundColor: Colors.red,
    );
  }

  bool hasInternet = false;

  checkInternetConnection() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (!hasInternet) {
      Fluttertoast.showToast(
          msg: "No Internet Connection", backgroundColor: Colors.red);
    } else {
      Timer(const Duration(seconds: 2), () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MySplashScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Please check your internet connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Brand-Regular",
                )),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                checkInternetConnection();
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
