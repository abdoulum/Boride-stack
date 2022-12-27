import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TestUI extends StatefulWidget {
  const TestUI({Key? key}) : super(key: key);

  @override
  State<TestUI> createState() => _TestUIState();
}

class _TestUIState extends State<TestUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text(
          "TEXT UI",
          style: TextStyle(color: Colors.black, fontFamily: 'Brand-Regular'),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0)),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 2,
                width: 27,
              ),
              const SizedBox(
                height: 5,
              ),
              const Center(
                child: Text(
                  "6min, 1.6Km away",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            "DKA-707-FV",
                              style: TextStyle(fontFamily: "Brand-bold", fontSize: 18)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Text("Toyota-Corolla, Black", style: TextStyle(fontFamily: "Brand-regular"),)
                    ],
                  ),
                 const Spacer(),
                  Transform.scale(
                    scaleX: -1,
                    child: Image.asset(
                      "images/uber-x.png",
                      scale: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('images/download.jpg'),
                    radius: 29,
                    //width: MediaQuery.of(context).size.width * 0.15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Ahmad Umar",
                              style: TextStyle(fontFamily: "Brand-regular")
                          )),
                      Row(
                        children: const [
                          Icon(
                            Icons.star,
                            size: 14,
                          ),
                          Text("4.5, ", style: TextStyle(fontFamily: "Brand-regular")),
                          Text("100+ trips", style: TextStyle(fontFamily: "Brand-regular"))
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.phone)),
                  const SizedBox(width: 5,),
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50)),
                      child:IconButton(
                        icon: const Icon(Ionicons.car_sport),
                        color: Colors.red,
                        onPressed: () {
                          // if (userRideRequestStatus !=
                          //     "onride") {
                          //   cancelRide();
                          //   cancelRideRequest();
                          //   resetApp();
                          // }
                        },
                      ),
                  )],
              ),
            ],
          )),
    );
  }
}
