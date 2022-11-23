import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TestUi extends StatelessWidget {
  const TestUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //ui for displaying assigned driver information

      body: Stack(children: [
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 0.9,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Column(
                    children:  [
                      Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Text(
                               "Safety Options",
                               style: TextStyle(
                                   fontSize: 24,
                                   color: Colors.black54,
                                   fontFamily: "Brand-Bold"),
                             ),
                             Spacer(),
                             IconButton(onPressed: () {}, icon: Icon(Ionicons.close_circle_outline))
                           ],
                         ),
                         Text(
                           "These safety options are here to help you in the case of emergency situations",
                           style: TextStyle(
                               fontSize: 16,
                               color: Colors.black54,
                               fontFamily: "Brand-Regular"),
                         ),
                       ],
                     ),
                      SizedBox(height: 15,),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.antenna_radiowaves_left_right,
                                color: Colors.black54,
                              ),
                              const SizedBox(
                                width: 14.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Share ride details",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text("Share your live location and car info",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.radio,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 14.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Emergency assist",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text("Call local authority",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      )
                    ])),
          ),
        ),
      ]),
    );
  }
}
