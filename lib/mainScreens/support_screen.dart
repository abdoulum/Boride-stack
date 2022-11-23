import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            "Support",
            style: TextStyle(
                fontFamily: "Brand-Regular", color: Colors.black, fontSize: 24),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children:  [
            const Center(child: Icon(CupertinoIcons.headphones, size: 100,color: Color.fromARGB(
                180, 150, 90, 250),)),
            const SizedBox(height: 10,),
            const Text("How can we help you?", style: TextStyle(fontSize: 25, fontFamily: "Brand-Regular", fontWeight: FontWeight.bold),),
            const SizedBox(height: 250,),
            Column(
              children: [
                Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 200, 200, 250),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(Icons.email_outlined, color:Color.fromARGB(
                        180, 150, 90, 250),size: 25,),

                  ),
                ),
                const SizedBox(height: 10,),
                Text("Contact us via email:", style: TextStyle(color: Colors.grey.shade500,fontSize: 15, fontFamily: "Brand-Regular"),),
                const SizedBox(height: 2,),
                const Text("Boridehq@gmail.com", style: TextStyle(fontSize: 15, fontFamily: "Brand-Regular", fontWeight: FontWeight.bold),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
