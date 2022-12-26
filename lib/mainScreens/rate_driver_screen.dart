import 'package:boride/assistants/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;

  RateDriverScreen({Key? key, this.assignedDriverId}) : super(key: key);

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {

  Color? color ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white60,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22.0,
              ),
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              const Divider(
                height: 4.0,
                thickness: 4.0,
              ),
              const SizedBox(
                height: 22.0,
              ),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: color,
                borderColor: color,
                size: 46,
                onRatingChanged: (valueOfStarsChoosed) {
                  countRatingStars = valueOfStarsChoosed;

                  if (countRatingStars == 1) {
                    setState(() {
                      titleStarsRating = "Very Bad";
                      color = Colors.red.shade800;
                    });
                  }
                  if (countRatingStars == 2) {
                    setState(() {
                      titleStarsRating = "Bad";
                      color = Colors.red.shade500;

                    });
                  }
                  if (countRatingStars == 3) {
                    setState(() {
                      titleStarsRating = "Good";
                      color = Colors.yellow.shade400;

                    });
                  }
                  if (countRatingStars == 4) {
                    setState(() {
                      titleStarsRating = "Very Good";
                      color = Colors.green;

                    });
                  }
                  if (countRatingStars == 5) {
                    setState(() {
                      titleStarsRating = "Excellent";
                      color = Colors.green;

                    });
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),

              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "Brand-Bold",
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance
                        .ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("ratings");

                    rateDriverRef.once().then((snap) {
                      if (snap.snapshot.value == null) {
                        rateDriverRef.set(countRatingStars.toString());

                        Navigator.pop(context);
                      } else {
                        double pastRatings =
                            double.parse(snap.snapshot.value.toString());
                        double newAverageRatings =
                            (pastRatings + countRatingStars) / 2;
                        rateDriverRef.set(newAverageRatings.toStringAsFixed(2));

                        Navigator.pop(context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 74),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
