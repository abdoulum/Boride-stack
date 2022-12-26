import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/assistants/global.dart';
import 'package:boride/assistants/map_key.dart';
import 'package:boride/assistants/app_info.dart';
import 'package:boride/models/directions.dart';
import 'package:boride/models/predicted_places.dart';


class PlacePredictionTileDesign extends StatefulWidget
{
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        )
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred, Failed. No Response.")
    {
      return;
    }

    if(responseApi["status"] == "OK")
    {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;

      });

      Navigator.pop(context, "obtainedDropoff");
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: SizedBox(
        child: GestureDetector(
          onTap: () {
            getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
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
                      Text(widget.predictedPlaces!.main_text!.length > 30 ?
                        "${widget.predictedPlaces!.main_text!.substring(0, 30)}..." : widget.predictedPlaces!.main_text!,
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
                      Text( widget.predictedPlaces!.secondary_text!.length > 40 ?
                        widget.predictedPlaces!.secondary_text!.substring(0, 40) : widget.predictedPlaces!.secondary_text!,
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
