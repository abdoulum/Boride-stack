// ignore_for_file: prefer_const_constructors
import 'package:boride/authentication/registration.dart';
import 'package:boride/mainScreens/main_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:boride/brand_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth= FirebaseAuth.instance;

  void login() async {
    showDialogg();

    final User? user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    )).user;

    if(user != null) {
      //verify login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children:  const [
              SizedBox(width: 5,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(BrandColors.colorAccent)),
              SizedBox(width: 5,),
              Text("Logging you in", style: TextStyle(fontSize: 15),)
            ],
          ),
        ),
      ),
    );
  }
  void showSnackBer(String title) {
    final snackBar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage("images/logo.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Sign in to request a ride',
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle:
                          TextStyle(fontSize: 20, fontFamily: 'Brand_Bold', fontWeight: FontWeight.w300),
                          hintStyle:
                          TextStyle(fontSize: 20, fontFamily: 'Brand_Bold', fontWeight: FontWeight.w300),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                          TextStyle(fontSize: 20, fontFamily: 'Brand_Bold', fontWeight: FontWeight.w300),
                          hintStyle:
                          TextStyle(fontSize: 20, fontFamily: 'Brand_Bold', fontWeight: FontWeight.w300),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        onPressed: () async{
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBer("No Internet connectivity");
                            return;
                          }

                          if(!emailController.text.contains("@")) {
                            showSnackBer("Please enter a valid email address");
                            return;
                          }
                          if(passwordController.text.length <8) {
                            showSnackBer("Password must be >8 characters");
                            return;
                          }

                          login();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: Colors.blue ,
                        textColor: Colors.white,
                        child:  SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style: const TextStyle(
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
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> RegistrationPage()));
                  },
                  child: Text(
                    "Don't have an account, Sign up here",
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
