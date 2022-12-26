import 'package:boride/assistants/global.dart';
import 'package:boride/mainScreens/search_favorite_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({Key? key}) : super(key: key);

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: const Text(
          "Add Favorite",
          style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1, vertical: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Home", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => SearchFavorite(from: "home")));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(userHomeAddress.isNotEmpty
                                  ? userHomeAddress
                                  : "Home location ", style: const TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 14,

                              ),)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Favorite 1", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => SearchFavorite(from: "favorite1")));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(userFavoriteAddress.isNotEmpty
                                  ? userFavoriteAddress
                                  : "Favorite location", style: const TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 14,

                              ),)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Favorite 2", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),),
                      const SizedBox(height: 5,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => SearchFavorite(from: "favorite2")));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 245, 247),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(userFavoriteAddress2.isNotEmpty
                                  ? userFavoriteAddress2
                                  : "Favorite location 2", style: const TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 14,

                              ),)
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 370,
                    child: Center(
                      child: Text(
                        "You can always update your favorite location here",
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40,),
                  GestureDetector(
                    onTap: () {
                      saveFavoriteLocations();

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Brand-Regular",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),

    );
  }

  saveFavoriteLocations() async {
    final prefs = await SharedPreferences.getInstance();
    if (userHomeAddress.isNotEmpty) {
      prefs.setString('my_home_address', userHomeAddress);
      prefs.setString('my_home_address_id', userHomeAddressId);
      FirebaseDatabase.instance.ref().child("users").child(fAuth.currentUser!.uid)
          .child("favorite_location").child("my_home_address_id").set(userHomeAddressId);
    }

    if (userFavoriteAddressId.isNotEmpty) {
      prefs.setString('my_favorite_address', userFavoriteAddress);
      prefs.setString('my_favorite_address_id', userFavoriteAddressId);
      FirebaseDatabase.instance.ref().child("users").child(fAuth.currentUser!.uid)
          .child("favorite_location").child("my_favorite_address_id").set(userFavoriteAddressId);
    }
    if (userFavoriteAddress2Id.isNotEmpty) {
      prefs.setString('my_favorite_address2', userFavoriteAddress2);
      prefs.setString('my_favorite_address2_id', userFavoriteAddress2Id);
      FirebaseDatabase.instance.ref().child("users").child(fAuth.currentUser!.uid)
          .child("favorite_location").child("my_favorite_address2_id").set(userFavoriteAddress2Id);
    }
    Navigator.pop(context);
  }
}
