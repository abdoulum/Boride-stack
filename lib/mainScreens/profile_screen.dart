import 'package:boride/assistants/assistant_methods.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/global/global.dart';
import 'package:boride/mainScreens/edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.06,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Ionicons.arrow_back,
                          color: Colors.black,
                        ),
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
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name
                        Row(
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.person_rounded),
                                  color: Colors.grey[400],
                                  iconSize: 45,
                                  onPressed: () {},
                                ),
                                const SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userModelCurrentInfo!.name !=null ? userModelCurrentInfo!.name! : "Loading Data..." ,
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: "Brand-Regular",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 0.9,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 385,
                          child: Divider(
                            color: Colors.grey.shade200,
                            thickness: 8,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 18),
                                child: const Icon(Icons.email_outlined)),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Text( userModelCurrentInfo!.email !=null ? userModelCurrentInfo!.email!.substring(0, 20) : "Loading Data...",
                                  style: const TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    //fontWeight: FontWeight.bold,
                                  )),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SizedBox(
                                height: 30,
                                width: 75,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text(
                                    "Verify",
                                    style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 18),
                                child: const Icon(Icons.phone_outlined)),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                                  style: const TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    //fontWeight: FontWeight.bold,
                                  )),
                            ),
                            const Spacer(),

                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 14.0, bottom: 10, top: 10),
                                child: Text(
                                  "Favorite Places",
                                  style: TextStyle(
                                    fontFamily: "Brand-Bold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.home_outlined,
                                      size: 22,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Icon(

                                      Icons.work_outline,
                                      size: 22,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Work",
                                      style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 370,
                                child: Divider(
                                  thickness: 0.2,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),



                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage()));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(100, 200, 200, 250),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.edit),
                                SizedBox(width: 40),
                                Expanded(
                                  child: Text(
                                    'Edit ',
                                    style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(100, 200, 200, 250),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Ionicons.log_out_outline),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(100, 200, 200, 250),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Ionicons.trash, color: Colors.red,),
                              SizedBox(width: 40,),
                              Expanded(
                                child: Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        //phone
                        //        InfoDesignUIWidget(
                        //    textInfo: userModelCurrentInfo!.phone!,
                        //    iconData: Icons.phone_iphone_rounded,
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
