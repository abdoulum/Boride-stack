import 'package:boride/brand_colors.dart';
import 'package:boride/mainScreens/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
              children: [
                SizedBox(
                  child: Center(
                    child: Image.asset(
                      "images/boride_logoD.png",
                      scale: MediaQuery.of(context).size.aspectRatio * 5.5,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Column(
                      children: const [
                        Text(
                          "Get Home. Get Around !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Brand-Bold",
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //about you & your company - write some info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Welcome to Boride, the ride hailing Service where we put our users first."
                            " We are dedicated to making sure Our users have the best experience "
                            "possible, From your first ride, to every ride thereafter, we are committed. ",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Brand-Regular",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 1,
                                color: Colors.transparent,
                                child: const Center(
                                  child: Text(
                                    "Rate our app",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: BrandColors.colorTextM,
                                        fontFamily: "brand-regular"),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 2,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  _launchInstagram();
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width * 1,
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Text(
                                      "Follow us on Instagram",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: BrandColors.colorTextM,
                                          fontFamily: "brand-regular"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              "https://boride.app/?page_id=262")));
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width * 1,
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Text(
                                      "Terms & Conditions",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: BrandColors.colorTextM,
                                          fontFamily: "brand-regular"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebPage(
                                              "https://boride.app/?page_id=3")));
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width * 1,
                                  color: Colors.transparent,
                                  child: const Center(
                                    child: Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: BrandColors.colorTextM,
                                          fontFamily: "brand-regular"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          )),
          const Padding(

            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Developed By UATech"
              "\nNigeria",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: BrandColors.colorTextP,
                  fontSize: 15,
                  fontFamily: "Brand-Regular"),
            ),
          )
        ],
      ),
    );
  }

  _launchInstagram() async {
    var nativeUrl = "instagram://user?username=boride_ng";
    var webUrl = "https://www.instagram.com/boride_ng";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }
}
