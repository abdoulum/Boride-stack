import 'package:boride/brand_colors.dart';
import 'package:boride/mainScreens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Enter your number",
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0.5,
                                spreadRadius: 0.1,
                                offset: Offset(0.1, 0.2))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "+234 ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Brand-Regular",
                                  color: BrandColors.colorTextSemiLight),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Center(
                                  child: TextField(
                              cursorColor: Colors.pink,
                              cursorHeight: 25,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              controller: phoneController,
                              maxLines: 1,style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Brand-Regular",
                                      color: BrandColors.colorTextSemiLight),
                              decoration: const InputDecoration(
                                  hintText: "Phone",
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 10.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                              ),
                            ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: otpVisibility,
                      child: TextField(
                        controller: otpController,
                        decoration: const InputDecoration(
                          hintText: 'OTP',
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(''),
                          ),
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      color: Colors.indigo[900],
                      onPressed: () {
                        if (otpVisibility) {
                          verifyOTP();
                        } else {
                          loginWithPhone();
                        }
                      },
                      child: Text(
                        otpVisibility ? "Verify" : "Login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text(
                "Terms & condition will apply if you are creating a new account",
                style: TextStyle(fontSize: 12, fontFamily: "Brand-Regular"),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+234${phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Map userMap = {"id": user!.uid};

          DatabaseReference reference =
              FirebaseDatabase.instance.ref().child("users").child(user!.uid);
          reference.set(userMap);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }
}
