import 'package:boride/brand_colors.dart';
import 'package:boride/widgets/taxibutton.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void showSnackBar(String title) {
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
      showSnackBar(thisEx.message!);
    })).user;

    // Check if user registration is successful
    if (user != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child('users/${user.uid}');

      //Prepare data to be saved
      Map userMap = {
        "id": user.uid,
        "name": fullNameController.text.trim(),
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
                      // Fullname
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 10,),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        title: 'REGISTER',
                        color: BrandColors.colorGreen,
                        onPressed: () async{

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(fullNameController.text.length < 3){
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }

                          if(phoneController.text.length < 10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                          if(passwordController.text.length < 8){
                            showSnackBar('password must be at least 8 characters');
                            return;
                          }

                          registerUser();

                        },
                      ),
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
