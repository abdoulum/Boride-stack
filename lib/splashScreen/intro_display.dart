import 'package:boride/authentication/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "How Does it Work?",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(0),
                child: Center(
                    child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        'images/undraw_mobile_login_re_9ntv.svg',
                        height: 120,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: const Text(
                        "1.Enter Phone Number \n2.Then Full Name \nand Email",
                        style: TextStyle(
                            fontFamily: "Brand-Regular", fontSize: 16),
                      ),
                    )
                  ],
                ))),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        'images/undraw_my_location_re_r52x.svg',
                        height: 130,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: const Text(
                        "Search The Location",
                        style: TextStyle(
                            fontFamily: "Brand-Regular", fontSize: 16),
                      ),
                    )
                  ],
                ))),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Get Matched With A Driver",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Brand-Regular", fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        'images/undraw_profile_details_re_ch9r.svg',
                        height: 130,
                      ),
                    ),
                  ],
                ))),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        'images/undraw_current_location_re_j130.svg',
                        height: 130,
                        width: 2000,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: const Text(
                          "Add Favorite locations In Settings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Brand-Regular", fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text(
                      "And you are done",
                      style:
                          TextStyle(fontFamily: "Brand-Regular", fontSize: 16),
                    ),
                    SvgPicture.asset(
                      'images/undraw_accept_terms_re_lj38.svg',
                      height: 130,
                    ),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: CupertinoColors.systemIndigo,
                  borderRadius: BorderRadius.circular(10)),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(
                      fontFamily: "Brand-Bold",
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
