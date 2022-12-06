import 'package:boride/assistants/app_info.dart';
import 'package:boride/splashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(
    Phoenix(
      child: MyApp(
        child: ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            restorationScopeId: "root",
            title: 'Drivers App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MySplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  const MyApp({Key? key, this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Key key = UniqueKey();

  void restartApp() {
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
