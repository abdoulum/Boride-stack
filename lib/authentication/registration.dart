import 'package:boride/brand_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {



  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void showSnackBer(String title) {
    final snackBar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  registerUser() async {
    showDialogg();
    final User? user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text).catchError((ex) {

      //check and display error message
      PlatformException thisEx = ex;
      showSnackBer(thisEx.message!);
    })).user;

    // Check if user registration is successful
    if (user != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('users/${user.uid}');

      //Prepare data to be saved
      Map userMap = {
        "id": user.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      };

      newUserRef.set(userMap);
      navigateToLoginPage();
    }
  }

  showDialogg() {
    Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children:  const [
              SizedBox(width: 5,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(BrandColors.colorAccent)),
              SizedBox(width: 5,),
              Text("Creating your account", style: TextStyle(fontSize: 15),)
            ],
          ),
        ),
      ),
    );
  }

  navigateToLoginPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage("images/logo.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Brand_Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                          hintStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                          hintStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                          hintStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                          hintStyle:
                          TextStyle(fontSize: 18, fontFamily: 'Brand_Bold'),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        onPressed: () async{

                          if (nameController.text.length <= 3) {
                            showSnackBer("Please enter a valid name");
                          }
                          if (phoneController.text.length < 10) {
                            showSnackBer("Please enter a valid phone number");
                          }
                          if (passwordController.text.length < 8) {
                            showSnackBer("Please enter a valid phone number");
                          }
                          else {
                            registerUser();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: BrandColors.colorBlue,
                        textColor: Colors.white,
                        child: const SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Brand_Bold'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account?, Log in",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
