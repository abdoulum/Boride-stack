import 'package:boride/assistants/global.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/mainScreens/promo_code.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  String? percentageDiscount;
  bool hasDiscount = false;

  @override
  void initState() {
    super.initState();
    checkPromo();
  }

  checkPromo() {
    DatabaseReference promoRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(fAuth.currentUser!.uid)
        .child("promo");
    promoRef.child("percentageDiscount").once().then((snap) {
      if (snap.snapshot.value != null) {
        setState(() {
          percentageDiscount = snap.snapshot.value.toString();
          hasDiscount = true;

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Promotions",
            style: TextStyle(
                fontFamily: "Brand-Regular", color: Colors.black, fontSize: 24),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PromoCode()));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 55,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 223, 225, 227),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                      child: Text(
                        "Enter promo code",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Brand-Regular",
                            color: BrandColors.colorTextSemiLight),
                      )),
                ),
              ),
              hasDiscount
                  ? Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: const [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              Colors.indigo.shade500,
                              Colors.indigo.shade600,
                              Colors.indigo.shade800,
                              Colors.indigo.shade900,
                            ],
                          ),
                          //color: const Color.fromARGB(150, 200, 200, 250),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Ionicons.gift_outline,
                                  color: Colors.white,
                                  //color: Color.fromARGB(228, 255, 255, 255),
                                  size: 35,
                                ),
                                const SizedBox(
                                  width: 70,
                                ),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Discount Bonus",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              228, 255, 255, 255),
                                          fontSize: 20,
                                          fontFamily: "Brand-bold",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You are currently on a $percentageDiscount% Discount",
                                style: const TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 17,
                                  color: Color.fromARGB(228, 255, 255, 255),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "images/boride_logo.png",
                                  scale: 5.5,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: MediaQuery.of(context).size.height * 0.1),
                        child: const Center(
                          child: Text(
                            "You do not have any promo available",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontFamily: "brand-bold"),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyCode() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Verifying code",
      ),
    );
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
