import 'package:boride/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  String discountCode = "";

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
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 225, 227),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: TextFormField(
                  onChanged:(value) {
                    discountCode = value;
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(null)],
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: "Promo-code",
                    hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                    labelStyle: TextStyle(fontFamily: "Brand-Regular"),
                    // prefixIcon: Icon(Icons.person),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    verifyCode();
                  },
                  child: const Text(
                    "Add Voucher",
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                    ),
                  )),
            ),
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 200, 200, 250),
                  borderRadius: BorderRadius.circular(20)),
            ),



          ],
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
