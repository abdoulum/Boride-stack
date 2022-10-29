import 'package:boride/brand_colors.dart';
import 'package:boride/global/global.dart';
import 'package:boride/mainScreens/about_screen.dart';
import 'package:boride/mainScreens/discount_offers_screen.dart';
import 'package:boride/mainScreens/profile_screen.dart';
import 'package:boride/mainScreens/trips_history_screen.dart';
import 'package:boride/splashScreen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({Key? key, this.name, this.email}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 165,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Brand-Bold",
                            color: BrandColors.colorTextDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.email.toString(),
                          style: const TextStyle(
                            fontFamily: "Brand-Bold",
                            fontSize: 12,
                            color: BrandColors.colorTextDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      builder: (c) => const TripsHistoryScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.reload, color: BrandColors.colorTextDark),
              title: Text(
                "History",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Bold",
                    fontWeight: FontWeight.w200,
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const DiscountScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.pricetag, color: BrandColors.colorTextDark),
              title: Text(
                "Offers",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Bold",
                    fontWeight: FontWeight.w200,
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const ProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.person_outline,
                  color: BrandColors.colorTextDark),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Bold",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const AboutScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.information_circle_outline,
                  color: BrandColors.colorTextDark),
              title: Text(
                "About",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Bold",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              fAuth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(Ionicons.log_out_outline,
                  color: BrandColors.colorTextDark),
              title: Text(
                "Sign Out",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Brand-Bold",
                    color: BrandColors.colorTextDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
