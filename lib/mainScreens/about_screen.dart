import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
            child: Column(
              children: [
                SizedBox(
                  height: 230,
                  child: Center(
                    child: Image.asset(
                      "images/taxi.png",
                      width: 200,
                    ),
                  ),
                ),
                Column(
                  children: const [
                    //company name
                    Text(
                      "Boride",
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: "Brand-Regular",
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    //about you & your company - write some info
                    Text(
                      "This app has been developed by Muhammad Ali, "
                      "This is the world number 1 ride sharing app. Available for all. "
                      "20M+ people already use this app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Brand-Regular",
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Text(
                      "This app has been developed by Muhammad Ali, "
                      "This is the world number 1 ride sharing app. Available for all. "
                      "20M+ people already use this app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
          const Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Developed By UTech",
              style: TextStyle(fontSize: 16, fontFamily: "Brand-Regular"),
            ),
          ))
        ],
      ),
    );
  }
}
