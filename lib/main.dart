import 'package:boride/dataprovider/appdata.dart';
import 'package:boride/helper/helpermethods.dart';
import 'package:boride/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  HelperMethod.getCurrentUserInfo();

  runApp(
    MyApp(
      child: ChangeNotifierProvider(
        create: (context)=> AppData(),
        child: MaterialApp(
          title: 'Drivers App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Splash(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}



class MyApp extends StatefulWidget
{
  final Widget? child;

  const MyApp({Key? key, this.child}) : super(key: key);

  static void restartApp(BuildContext context)
  {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  Key key = UniqueKey();

  void restartApp()
  {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}



