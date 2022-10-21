import 'package:boride/assistant/assistant_methods.dart';
import 'package:boride/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {

  DatabaseReference referenceRideRequest;

  SelectNearestActiveDriversScreen({Key? key, required this.referenceRideRequest}) : super(key: key) ;

  @override
  _SelectNearestActiveDriversScreenState createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {

  String fareAmount = "";





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        widget.referenceRideRequest.remove();
                        dList.clear();
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Icon(
                        Ionicons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6,),
                  const Text('Cancel',style: TextStyle(
                    fontSize: 14,fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(

                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          "images/" +
                              dList[index]["car_details"]["type"].toString() +
                              ".png",
                          width: 70,
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dList[index]["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            dList[index]["car_details"]["car_model"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SmoothStarRating(
                            rating: 3.5,
                            color: Colors.grey,
                            borderColor: Colors.black,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:  [
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                              tripDirectionDetailsInfo !=null ? tripDirectionDetailsInfo!.duration_text! : "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 12),),

                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            tripDirectionDetailsInfo !=null ? tripDirectionDetailsInfo!.distance_text! : "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 12),)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
