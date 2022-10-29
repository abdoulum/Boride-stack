import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0,  ),
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
            )
          ],
        ),
      ),
    );
  }
}
