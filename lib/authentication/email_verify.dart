import 'dart:async';

import 'package:boride/assistants/global.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatefulWidget {
  String email;

  EmailVerify(this.email, {Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    verify();
  }

  verify() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    await fAuth.currentUser!.reload();
    if (fAuth.currentUser!.emailVerified) {
      timer!.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text(
          "Verify email",
          style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.email,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "we have sent you an email. Check your email inbox and click on the link attached to verify.",
              style: TextStyle(
                fontFamily: "Brand-Regular",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () {
                  fAuth.currentUser!.verifyBeforeUpdateEmail(widget.email);
                },
                child: const Text("Resend email",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Brand-Regular",
                        fontSize: 18))),
          ],
        ),
      ),
    );
  }
}
