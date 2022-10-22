import 'package:boride/brand_colors.dart';
import 'package:boride/dataprovider/appdata.dart';
import 'package:boride/datamodels/Prediction.dart';
import 'package:boride/helper/requesthelper.dart';
import 'package:boride/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../global/map_key.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  List<Prediction> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {

    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:NG";

      var responseAutoCompleteSearch =
          await RequestHelper.getRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => Prediction.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String address =
        Provider.of<AppData>(context).pickupAddress!.placeName ?? " ";
    pickupController.text = address;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, left: 24, right: 24, bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Set Destination",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),
                  Row(
                    children: [
                      const Icon(
                        Ionicons.pin_outline,
                        color: Colors.green,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextField(
                              controller: pickupController,
                              onChanged: (valueTyped) {},
                              decoration: const InputDecoration(
                                hintText: "Pickup location",
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(
                        Ionicons.location_outline,
                        color: Colors.blueAccent,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              controller: destinationController,
                              onChanged: (valueTyped)
                              {
                                findPlaceAutoCompleteSearch(valueTyped);
                              },
                              decoration: const InputDecoration(
                                hintText: "Where to",
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (placesPredictedList.isNotEmpty)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placesPredictedList.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 1,
                        color: Colors.white,
                        thickness: 1,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
