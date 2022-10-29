import 'package:boride/infoHandler/app_info.dart';
import 'package:boride/widgets/history_design_ui.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
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
                    "Ride History",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Brand-Bold",
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, i) => const Divider(
                  color: Colors.white,
                  thickness: 2,
                  height: 2,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    color: Colors.white54,
                    child: HistoryDesignUIWidget(
                      tripsHistoryModel:
                          Provider.of<AppInfo>(context, listen: false)
                              .allTripsHistoryInformationList[i],
                    ),
                  );
                },
                itemCount: Provider.of<AppInfo>(context, listen: false)
                    .allTripsHistoryInformationList
                    .length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
