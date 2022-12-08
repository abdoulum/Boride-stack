import 'package:boride/brand_colors.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/mainScreens/about_screen.dart';
import 'package:boride/mainScreens/promo_screen.dart';
import 'package:boride/mainScreens/profile_screen.dart';
import 'package:boride/mainScreens/support_screen.dart';
import 'package:boride/mainScreens/trip_history_screen.dart';
import 'package:boride/splashScreen/splash_screen.dart';
import 'package:boride/testui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyDrawer extends StatefulWidget {

  MyDrawer({Key? key,}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  String name = "";

  @override
  void initState()  {
    super.initState();
    fetchData();
  }


  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('my_name') ?? userModelCurrentInfo!.name!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          //drawer header
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => const Profile()));
            },
            child: Container(
              height: 140,

              child: DrawerHeader(
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    const Icon(
                      Ionicons.person_circle,
                      size: 60,
                      color: Colors.black,
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    ///Email And Name
                   Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Brand-Regular",
                              color: BrandColors.colorTextDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Text("Visit profile",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Brand-Regular",
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          const Divider(
            thickness: 0.2,
            color: Colors.black,
          ),

          const SizedBox(
            height: 12.0,
          ),

          //drawer body
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) =>  HistoryPage()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.reload, color: BrandColors.colorTextDark),
              title: Text(
                "History",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.w200,
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const DiscountScreen()));
            },
            child: const ListTile(
              leading:
                  Icon(Ionicons.pricetag_outline, size: 25,color: BrandColors.colorTextDark),
              title: Text(
                "Offers",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.w200,
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Share.share('https://boride.page.link/referral');
            },
            child: const ListTile(
              leading: Icon(Ionicons.person_add_outline,
                  size: 25,
                  color: BrandColors.colorTextDark),
              title: Text(
                "Invite friends",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Regular",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) =>   AboutScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.information_circle_outline,
                  size: 25,
                  color: BrandColors.colorTextDark),
              title: Text(
                "About",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Regular",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) =>   const Support()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.help_circle_outline,
                  size: 25,
                  color: BrandColors.colorTextDark),
              title: Text(
                "Support",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Regular",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
