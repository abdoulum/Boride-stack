import 'package:boride/models/history.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HistoryTile extends StatelessWidget {
  final TripsHistoryModel? history;

  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(150, 200, 200, 250),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //driver name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "Rider: ${history!.driverName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Brand-Regular",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "\$ ${history!.fareAmount!}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            Row(
              children: [
                const Icon(
                  Ionicons.pin,
                  color: Colors.indigo,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    history!.pickup!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Icon(
                  Ionicons.location,
                  color: Colors.greenAccent.shade700,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    history!.dropoff!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
