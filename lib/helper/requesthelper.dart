import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper
{
  static Future<dynamic> getRequest(String url) async
  {
    http.Response response = await http.get(Uri.parse(url));

    try
    {
      if(response.statusCode == 200) //successful
      {
        String responseData = response.body; //json

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      }
      else
      {
        return "Error Occurred, Failed. No Response.";
      }
    }
    catch(exp)
    {
      return "Error Occurred, Failed. No Response.";
    }
  }
}