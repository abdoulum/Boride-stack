import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../authentication/login_page.dart';

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
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 120,
            color: Colors.white,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Ionicons.person_circle,
                    size: 40,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.email.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 25.0,
          ),

          //drawer body
          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Ionicons.refresh,
                color: Colors.black87,
                size: 25,
              ),
              title: Text(
                "Ride History",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Ionicons.card_outline,
                color: Colors.black,
              ),
              title: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Ionicons.pricetag_outline,
                color: Colors.black,
              ),
              title: Text(
                "Deals",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Ionicons.chatbox_ellipses_outline,
                color: Colors.black,
              ),
              title: Text(
                "Tracker",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Ionicons.information_circle_outline,
                color: Colors.black,
              ),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => const LoginPage()));
            },
            child: const ListTile(
              leading: Icon(
                Ionicons.information_circle_outline,
                color: Colors.black,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
