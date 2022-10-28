import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/infoHandler/app_info.dart';
import 'package:boride/models/predicted_places.dart';
import 'package:boride/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../global/map_key.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {

    if (inputText.length > 1) //2 or more than 2 input characters
        {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:NG";

      var responseAutoCompleteSearch =
      await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
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
        Provider.of<AppInfo>(context).userPickUpLocation!.locationName ?? " ";
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
                  blurRadius: 1,
                  spreadRadius: 0.1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, left: 24, right: 24),
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
                            fontSize: 22.0,
                            fontFamily: "Brand-Bold",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Icon(
                        Ionicons.pin_outline,
                        color: BrandColors.colorGreen,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          alignment: const Alignment(-1, 0),
                          height: 50,
                          decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(address.substring(0, 28)  +
                              "...", style: const TextStyle(
                            fontFamily: "Brand-Bold",

                          ),),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(
                        Ionicons.location_outline,
                        color: BrandColors.colorPrimaryDark,
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
                                hintText: "Where to..",
                                hintStyle: TextStyle(
                                  color: BrandColors.colorTextSemiLight
                                ),
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
