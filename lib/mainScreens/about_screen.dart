import 'package:flutter/material.dart';


class AboutScreen extends StatefulWidget
{
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 50),
        child: ListView(

          children: [
            //image
             SizedBox(
              height: 230,
              child: Center(
                child: Image.asset(
                  "images/logo.png",
                  width: 260,
                ),
              ),
            ),

            Column(
              children: [

                //company name
                const Text(
                  "Uber & inDriver Clone",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //about you & your company - write some info
                const Text(
                  "This app has been developed by Muhammad Ali, "
                  "This is the world number 1 ride sharing app. Available for all. "
                  "20M+ people already use this app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Brand-Bold",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  "This app has been developed by Muhammad Ali, "
                      "This is the world number 1 ride sharing app. Available for all. "
                      "20M+ people already use this app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                //close
                ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white54,
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),

          ],

        ),
      ),
    );
  }
}
