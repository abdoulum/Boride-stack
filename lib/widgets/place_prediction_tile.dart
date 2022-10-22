import 'package:boride/dataprovider/appdata.dart';
import 'package:boride/global/map_key.dart';
import 'package:boride/helper/requesthelper.dart';
import 'package:boride/datamodels/address.dart';
import 'package:boride/datamodels/Prediction.dart';
import 'package:boride/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class PlacePredictionTileDesign extends StatelessWidget
{
  final Prediction? predictedPlaces;

  const PlacePredictionTileDesign({Key? key, this.predictedPlaces}) : super(key: key);


  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting Up Drop-Off, Please wait...", status: '',
      ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestHelper.getRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred, Failed. No Response.")
    {
      return;
    }

    if(responseApi["status"] == "OK")
    {
      Address directions = Address();
      directions.placeName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.latitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.longitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropoff");
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: ()
      {
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Ionicons.location_outline,
              color: Colors.blue,
            ),
            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  Text(
                    predictedPlaces!.main_text!,
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
                    predictedPlaces!.secondary_text!,
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
