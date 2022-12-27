import 'package:boride/assistants/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoCode extends StatefulWidget {
  const PromoCode({Key? key}) : super(key: key);

  @override
  State<PromoCode> createState() => _PromoCodeState();
}

class _PromoCodeState extends State<PromoCode> {
  String? discountCode;

  var percentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Enter Discount code",
                  style: TextStyle(fontSize: 22, fontFamily: "Brand-Regular"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 55,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(155, 223, 225, 227),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          discountCode = value;
                        });
                      },
                      inputFormatters: [LengthLimitingTextInputFormatter(null)],
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: "Enter Promo-code",
                        hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                        labelStyle: TextStyle(fontFamily: "Brand-Regular"),
                        // prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Depending on the discount code entered, promo will be applied to next ride",
                  style: TextStyle(fontSize: 14, fontFamily: "Brand-Regular"),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                      verifyDiscountCode();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Redeem",
                      style: TextStyle(fontFamily: "Brand-Regular"),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Invite friends to earn discounts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontFamily: "Brand-Regular"),
                ),
              ),
            ],
          ),
        ));
  }

  verifyDiscountCode() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Center(
        child: const CircularProgressIndicator(
          color: Colors.indigo,
        ),
      ),
    );

    DatabaseReference promoRef = FirebaseDatabase.instance.ref().child("promo");
    promoRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        Map values = snap.snapshot.value as Map;

        List<String> promoKeys = [];
        values.forEach((key, value) {
          promoKeys.add(key);
        });

        if (promoKeys.contains(discountCode)) {
          FirebaseDatabase.instance
              .ref()
              .child("promo")
              .child(discountCode!)
              .once()
              .then((snapshot) {
            if (snapshot.snapshot.value != null) {
              setState(() {
                percentage = snapshot.snapshot.value;
              });
              FirebaseDatabase.instance
                  .ref()
                  .child("users")
                  .child(fAuth.currentUser!.uid)
                  .child("promo")
                  .child("percentageDiscount")
                  .set(percentage)
                  .whenComplete(() {
                Fluttertoast.showToast(msg: "Redeem successful");
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "Redeem failed. Discount code is not valid");
          Navigator.pop(context);
        }
      }
    });
  }
}
