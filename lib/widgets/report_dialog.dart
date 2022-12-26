import 'package:boride/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedIssue = "";

  List<String> issues = [
    'Ride did not happen',
    'Driver was rude',
    'Recover a lost item',
    'Driver followed a slower route',
    'Price was higher than expected',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          "Report Driver",
          style: TextStyle(color: Colors.black, fontFamily: "Brand-Regular"),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          margin: const EdgeInsets.all(8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                "What is your issue ?",
                style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),

              const Text(
                "Please select the issue that best describe your problem",
                style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontSize: 16,
                    color: BrandColors.colorTextI),
              ),

              const SizedBox(height: 20),

              ListView.separated(
                separatorBuilder: (context, i) => const Divider(
                  thickness: 0.2,
                  height: 5,
                  color: Colors.black,
                ),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: issues[i].toString());
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Text(
                              issues[i],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Brand-regular",
                                  color: BrandColors.colorTextI),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: BrandColors.colorTextP,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: issues.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
