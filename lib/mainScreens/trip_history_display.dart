import 'package:boride/models/history.dart';
import 'package:boride/widgets/report_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TripHistoryDisplay extends StatefulWidget {
  int? index;
  TripsHistoryModel? tripsHistoryModel;

  TripHistoryDisplay({
    Key? key,
    this.tripsHistoryModel,
    this.index,
  }) : super(key: key);

  @override
  State<TripHistoryDisplay> createState() => _TripHistoryDisplayState();
}

class _TripHistoryDisplayState extends State<TripHistoryDisplay> {
  String name = "";
  String phone = "";
  String price = "";
  String photo = "";
  String status = "";

  Color color = const Color.fromARGB(50, 200, 200, 200);

  @override
  Widget build(BuildContext context) {
    // id = Provider.of<AppInfo>(context).driverList[widget.index!].id.toString();
    name = widget.tripsHistoryModel!.driverName.toString();
    phone = widget.tripsHistoryModel!.driverPhone.toString();
    price = widget.tripsHistoryModel!.fareAmount.toString();
    photo = widget.tripsHistoryModel!.driverPhoto.toString();
    status = widget.tripsHistoryModel!.status.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Trip Information",
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
      body: Column(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Status:  ${status}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Brand-Regular"),
                          ),
                          const Spacer(),
                          ClipOval(
                            child: Image.network(
                              photo,
                              height: 60,
                              width: 60,
                              scale: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Name:  $name",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Phone:  $phone",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Fare amount:  $price",
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "Brand-Regular")),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.pin,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.tripsHistoryModel!.pickup!.length > 32
                                  ? widget.tripsHistoryModel!.pickup!
                                      .substring(0, 32)
                                  : widget.tripsHistoryModel!.pickup!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: "Brand-Regular",
                              ),
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
                            Ionicons.location,
                            color: Colors.indigo,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              widget.tripsHistoryModel!.dropoff!.length > 28
                                  ? widget.tripsHistoryModel!.dropoff!
                                      .substring(0, 28)
                                  : widget.tripsHistoryModel!.dropoff!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(25),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context, builder: (context) => const ReportPage());
            },
            onDoubleTap: () {},
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text("Report Driver",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Brand-Bold")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
