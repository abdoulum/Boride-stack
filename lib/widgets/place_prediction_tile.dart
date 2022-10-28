import 'package:boride/assistants/request_assistant.dart';
import 'package:boride/brand_colors.dart';
import 'package:boride/global/map_key.dart';
import 'package:boride/models/directions.dart';
import 'package:boride/models/predicted_places.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:boride/global/global.dart';
import 'package:boride/infoHandler/app_info.dart';


class PlacePredictionTileDesign extends StatefulWidget
{
  final PredictedPlaces? predictedPlaces;

  const PlacePredictionTileDesign({Key? key, this.predictedPlaces}) : super(key: key);

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting Up Drof-Off, Please wait...",
        ),
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
    return ElevatedButton(
      onPressed: ()
      {
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const Icon(
              Ionicons.location_outline,
              color: BrandColors.colorPrimaryDark,
            ),
            const SizedBox(width: 15.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Brand-Bold",
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 2.0,),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Brand-Bold",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
