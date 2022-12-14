import 'package:boride/assistants/app_info.dart';
import 'package:boride/mainScreens/trip_history_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/history_design_ui.dart';

class TripsHistoryScreen extends StatefulWidget {
  const TripsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();
}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Trips History",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "Brand-Regular",
                color: Colors.black)),
        elevation: 1,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
        ),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripHistoryDisplay(
                                index: i,
                                tripsHistoryModel:
                                    Provider.of<AppInfo>(context, listen: false)
                                        .tripsData[i],
                              )));
                },
                child: HistoryTile(
                  history:
                      Provider.of<AppInfo>(context, listen: false).tripsData[i],
                ),
              ),

            ),
          );
        },
        itemCount:
            Provider.of<AppInfo>(context, listen: false).tripsData.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
