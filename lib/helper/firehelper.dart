
import 'package:boride/datamodels/nearbydriver.dart';

class FireHelper
{
  static List<NearbyDriver> nearbyDriverList = [];

  static void removeFromList(String key)
  {
    int indexNumber = nearbyDriverList.indexWhere((element) => element.key == key);
    nearbyDriverList.removeAt(indexNumber);
  }

  static void updateNearbyLocation(NearbyDriver driver)
  {
    int indexNumber = nearbyDriverList.indexWhere((element) => element.key == driver.key);

    nearbyDriverList[indexNumber].locationLatitude = driver.locationLatitude;
    nearbyDriverList[indexNumber].locationLongitude = driver.locationLongitude;
  }
}