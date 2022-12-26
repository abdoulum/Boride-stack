import 'package:boride/assistants/global.dart';
import 'package:boride/authentication/email_verify.dart';
import 'package:boride/mainScreens/add_favorite.dart';
import 'package:boride/mainScreens/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('my_name') ?? userModelCurrentInfo!.name!;
      email = prefs.getString('my_email') ?? userModelCurrentInfo!.email!;
      phone = fAuth.currentUser!.phoneNumber!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.06,
                left: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.01),
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
                        Center(
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(50)),
                                child: IconButton(
                                  icon: const Icon(Icons.person_rounded),
                                  color: Colors.grey[400],
                                  iconSize: 45,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: GestureDetector(
                                      child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            fontFamily: "Brand-regular",
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )),
                                      onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditPage()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 385,
                          child: Divider(
                            color: Colors.grey.shade200,
                            thickness: 4,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: const Icon(Icons.email_outlined)),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                  email.length > 28
                                      ? "${email.substring(0, 28)} ..."
                                      : email,
                                  style: const TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                    //fontWeight: FontWeight.bold,
                                  )),
                            ),
                            const Spacer(),
                            !fAuth.currentUser!.emailVerified
                                ? Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                      height: 30,
                                      width: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          _verifyEmail();
                                        },
                                        child: const Text(
                                          "Verify",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontFamily: "Brand-Regular",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 18),
                                child: const Icon(Icons.phone_outlined)),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(phone,
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 15, vertical: 10),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Padding(
                        //         padding: EdgeInsets.only(
                        //             left: 14.0, bottom: 10, top: 10),
                        //         child: Text(
                        //           "Favorite Places",
                        //           style: TextStyle(
                        //             fontFamily: "Brand-Bold",
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 18,
                        //           ),
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   children: const [
                        //                     Icon(Ionicons.home_outline),
                        //                     SizedBox(
                        //                       width: 20,
                        //                     ),
                        //                     Text("Work",
                        //                         style: TextStyle(
                        //                           fontFamily: "Brand-Regular",
                        //                           fontSize: 16.0,
                        //                           color: Colors.black,
                        //                           //fontWeight: FontWeight.bold,
                        //                         )),
                        //                   ],
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Row(
                        //                   children: const [
                        //                     Icon(Ionicons.briefcase_outline),
                        //                     SizedBox(
                        //                       width: 20,
                        //                     ),
                        //                     Text("Favorite ",
                        //                         style: TextStyle(
                        //                           fontFamily: "Brand-Regular",
                        //                           fontSize: 16.0,
                        //                           color: Colors.black,
                        //                           //fontWeight: FontWeight.bold,
                        //                         )),
                        //                   ],
                        //                 ),
                        //                 const SizedBox(
                        //                   height: 15,
                        //                 ),
                        //                 Row(
                        //                   children: const [
                        //                     Icon(Ionicons.location_outline),
                        //                     SizedBox(
                        //                       width: 20,
                        //                     ),
                        //                     Text("Favorite",
                        //                         style: TextStyle(
                        //                           fontFamily: "Brand-Regular",
                        //                           fontSize: 16.0,
                        //                           color: Colors.black,
                        //                           //fontWeight: FontWeight.bold,
                        //                         )),
                        //                   ],
                        //                 ),
                        //               ]),
                        //           Spacer(),
                        //           GestureDetector(
                        //             child: Container(
                        //                 height: 40,
                        //                 width: 40,
                        //                 decoration: BoxDecoration(
                        //                     color: Colors.grey.shade100,
                        //                     borderRadius:
                        //                     BorderRadius.circular(
                        //                         50)),
                        //                 child: const Icon(
                        //                   Icons.edit_outlined,
                        //                   size: 15,
                        //                 )),
                        //             onTap: () {
                        //               Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) =>
                        //                       const AddFavorite()));
                        //             },
                        //           )
                        //         ],
                        //       ),
                        //       SizedBox(
                        //         width: 370,
                        //         child: Divider(
                        //           thickness: 0.2,
                        //           height:
                        //               MediaQuery.of(context).size.height * 0.08,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child:
                                            const Icon(Ionicons.home_outline)),
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: const Text("Home",
                                          style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            //fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Icon(
                                            Ionicons.briefcase_outline)),
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: const Text("Work",
                                          style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            //fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Icon(
                                            Ionicons.location_outline)),
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: const Text("Favorite",
                                          style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            //fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) => const AddFavorite()));
                                      },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              fontFamily: "Brand-regular",
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                child: Divider(
                                  thickness: 0.1,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            fAuth.signOut().then((value) {
                              Phoenix.rebirth(context);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(100, 200, 200, 250),
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
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(100, 200, 200, 250),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Ionicons.trash,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 40,
                              ),
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

  _verifyEmail() {
    fAuth.currentUser!.verifyBeforeUpdateEmail(email).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EmailVerify(email)));
    });
  }
}
