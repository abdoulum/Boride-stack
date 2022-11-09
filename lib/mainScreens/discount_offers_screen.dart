import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Ionicons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Promotions",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Brand-Bold",
                   ),
              ),
            ),

            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Container(
                margin: const EdgeInsets.all(12),
                height: 55,
                width: 350,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 223, 225, 227),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(null)
                    ],
                    decoration: const InputDecoration(
                      hintText: "Discount Code",
                      hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                      labelStyle: TextStyle(fontFamily: "Brand-Regular"),
                      // prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
