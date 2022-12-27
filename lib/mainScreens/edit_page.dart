import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/mainScreens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String fullName = "";
  String email = "";

  String? sName;
  String? sEmail;
  String? sPhone;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text(
          "Edit Page",
          style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.08,
              right: MediaQuery.of(context).size.width * 0.08,
              top: MediaQuery.of(context).size.height * 0.05),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 240, 239, 242),
                                  blurRadius: 1.5,
                                  spreadRadius: 5.5),
                            ]),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.grey.shade600,
                          size: 80,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      height: 55,
                      width: 350,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 245, 247),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(null)
                          ],
                          decoration: const InputDecoration(
                            hintText: "Full Name",
                            hintStyle: TextStyle(fontFamily: "Brand-Regular"),
                            labelStyle: TextStyle(fontFamily: "Brand-Regular"),
                            // prefixIcon: Icon(Icons.person),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    fAuth.currentUser!.emailVerified
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.all(12),
                            height: 55,
                            width: 350,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 245, 247),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  hintStyle:
                                      TextStyle(fontFamily: "Brand-Regular"),
                                  //  prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 370,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            "Your Phone Number Cant Be Changed, If You Want To Link Your Account To another Phone Number, contact Customer Support.",
                            style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.2),
                      child: ElevatedButton(
                          onPressed: () async {
                            updateProfile();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontFamily: "Brand-Regular"),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    DatabaseReference profileRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);
    profileRef.child("name").set(fullName);
    profileRef.child("email").set(email);
    profileRef
        .child("phone")
        .set(FirebaseAuth.instance.currentUser!.phoneNumber);
    profileRef.child("id").set(FirebaseAuth.instance.currentUser!.uid);

    prefs.setString('my_name', fullName);
    prefs.setString('my_email', email);
    prefs.setString('my_phone', fullName);

    await AssistantMethods.readCurrentOnlineUserInfo();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainScreen()));
  }
}
