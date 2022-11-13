import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/authentication/login_screen.dart';
import 'package:boride/global/global.dart';
import 'package:boride/mainScreens/main_screen.dart';


class MySplashScreen extends StatefulWidget
{
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen>
{


  startTimer()
  {
    fAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;

    Timer(const Duration(seconds: 3), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const MainScreen()));

      }
      else
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    AssistantMethods.readCurrentOnlineUserInfo();
    startTimer();
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.blue,
        child: const Center(
          child: Text(
            "Boride.",
            style: TextStyle(
              fontSize: 65,
              fontFamily: "Brand-Regular",
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
