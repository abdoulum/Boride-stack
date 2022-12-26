import 'package:boride/authentication/otp.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/mainScreens/web_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNController = TextEditingController();
  var phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/boride_logo.png",
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.indigo,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Phone Verification",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "We need to register your phone to get you started!",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Brand-Regular",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 40,
                            child: Text(
                              "+234",
                              style: TextStyle(
                                  fontFamily: "Brand-Regular", fontSize: 16, color: BrandColors.colorTextP),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 40, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextField(
                            onChanged: (value) {
                              phone = value;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                                hintStyle:
                                    TextStyle(fontFamily: "Brand-Regular")),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (phone == "") {
                              Fluttertoast.showToast(
                                  msg: "Enter a valid number");
                            } else if (phone.length <= 9 ||
                                phone.length >= 12) {
                              Fluttertoast.showToast(
                                  msg: "Enter a valid number");
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext c) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.indigo,
                                      ),
                                    );
                                  });

                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: "+234$phone",
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  String verifyId = verificationId;
                                  String phoneN = phone;
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyVerify(verifyId, phoneN)));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "Send the code",
                            style: TextStyle(fontFamily: "Brand-Regular"),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WebPage("https://boride.app/?page_id=262")));
            },
            child: const Text("Terms & Conditions",
            style: TextStyle(
                fontFamily: "Brand-Regular",
                color: BrandColors.colorTextP,
                fontSize: 18)),
          )
        ],
      ),
    );
  }
}
