import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';


postFcmToken(String deviceId)async{
Map empty={};
final url = Uri.parse("https://notificationtest-acb49-default-rtdb.firebaseio.com/device_id.json");
Map deviceid= { Platform.isIOS? "ios_id": "device_id":deviceId};
final body = json.encode(deviceid);
final response = await http.post(url,body: body);

if(response.statusCode ==200){
  Map data = json.decode(response.body);
  log("Firebase response: $data");
  return data;
}else {
  return empty;
}


}