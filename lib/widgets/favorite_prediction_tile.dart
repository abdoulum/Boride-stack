import 'package:boride/assistants/app_info.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/assistants/map_key.dart';
import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/models/directions.dart';
import 'package:boride/models/predicted_places.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class FavoritePredictionTileDesign extends StatefulWidget {
  final PredictedPlaces? favoritePlaces;
  String? from;

  FavoritePredictionTileDesign({this.favoritePlaces, this.from});

  @override
  State<FavoritePredictionTileDesign> createState() =>
      _FavoritePredictionTileDesignState();
}

class _FavoritePredictionTileDesignState
    extends State<FavoritePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: const CircularProgressIndicator(
          color: Colors.indigo,
        ),
      ),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      if (widget.from == "home") {
        setState(() {
          userHomeAddress = directions.locationName!;
          userHomeAddressId = directions.locationId!;
        });
      } else if (widget.from == "favorite1") {
        setState(() {
          userFavoriteAddress = directions.locationName!;
          userFavoriteAddressId = directions.locationId!;
        });
      } else if (widget.from == "favorite2") {
        setState(() {
          userFavoriteAddress2 = directions.locationName!;
          userFavoriteAddress2Id = directions.locationId!;
        });
      }

      Navigator.pop(context, "obtainedDropoff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            getPlaceDirectionDetails(widget.favoritePlaces!.place_id, context);
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const Icon(
                    Ionicons.location,
                    color: Colors.indigo,
                  ),
                  const SizedBox(
                    width: 14.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.favoritePlaces!.main_text!.length > 30
                            ? "${widget.favoritePlaces!.main_text!.substring(0, 30)}..."
                            : widget.favoritePlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Brand-Regular",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        widget.favoritePlaces!.secondary_text!.length > 40
                            ? widget.favoritePlaces!.secondary_text!
                                .substring(0, 40)
                            : widget.favoritePlaces!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
