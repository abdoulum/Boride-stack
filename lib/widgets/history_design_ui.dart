import 'package:boride/models/history.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HistoryTile extends StatelessWidget {
  final TripsHistoryModel? history;

  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    "Driver: ${history!.driverName}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Brand-Bold",
                    ),
                  ),
                ),
                Text(
                  "\$ ${history!.fareAmount!}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Brand-Bold",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Ionicons.pin,
                  color: Colors.indigo,
                  size: 18,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    history!.pickup!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Ionicons.location,
                  color: Colors.greenAccent.shade700,
                  size: 18,
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
                      fontSize: 12,
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
