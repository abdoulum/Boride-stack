import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/global/global.dart';
import 'package:boride/widgets/info_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  String userName = "YourName";
  String userPhone = "YourPhone";

  @override
  void initState() {
    super.initState();
    AssistantMethods.readCurrentOnlineUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Ionicons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Brand-Bold",
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 100,
            ),
            //name
            Text(
               userName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand-Bold")),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
            ),

            const SizedBox(
              height: 38.0,
            ),

            //phone
            InfoDesignUIWidget(
              textInfo: userPhone,
              iconData: Icons.phone_iphone,
            ),

            //email
            InfoDesignUIWidget(
              textInfo: userPhone,
              iconData: Icons.email,
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
