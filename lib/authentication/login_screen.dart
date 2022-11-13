import 'package:boride/authentication/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNController = TextEditingController();
  var phone = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Text("Boride", style: TextStyle(
               fontSize: 60, fontFamily: "Brand-Regular",
               fontWeight: FontWeight.bold,
               color: Colors.blue
             ),),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22,fontFamily: "Brand-Regular", fontWeight: FontWeight.bold),
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
                height: 55,
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
                      child: Text("+234", style: TextStyle(fontFamily: "Brand-Regular", fontSize: 16),),
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
                            hintStyle: TextStyle(fontFamily: "Brand-Regular")
                          ),
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

                      if(phone == "") {
                        Fluttertoast.showToast(msg: "Enter a valid number");
                      }else if(phone.length <= 9 || phone.length >= 12) {
                        Fluttertoast.showToast(msg: "Enter a valid number");
                      }else {

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext c) {
                              return ProgressDialog(
                                message: "Processing, Please wait...",
                              );
                            });

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+234$phone",
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) {
                            String verifyId = verificationId;
                            String phoneN = phone;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyVerify(verifyId, phoneN)));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }


                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),

                    child: const Text("Send the code", style: TextStyle(fontFamily: "Brand-Regular"),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}