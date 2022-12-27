import 'package:boride/assistants/map_key.dart';
import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/models/predicted_places.dart';
import 'package:boride/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 2) //2 or more than 2 input characters
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //search place ui
          Container(
            height: 200,
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
              padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
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
                  const SizedBox(height: 35.0),
                  Row(
                    children: [
                      const Icon(
                        Ionicons.location_outline,
                        color: Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (valueTyped) {
                                findPlaceAutoCompleteSearch(valueTyped);
                              },
                              decoration: const InputDecoration(
                                hintText: "Where to..",
                                hintStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: BrandColors.colorTextSemiLight),
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
          Expanded(
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
        ],
      ),
    );
  }
}
