import 'dart:developer';
import 'dart:io';

import 'package:check_notification/demo_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';

import 'notificationservice/notification-service.dart';

DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String deviceTokenToSendPushNotification = '';


   //Device Info plugin 
   deviceInfo()async{
    try{
          
      if(Platform.isAndroid){
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        log("Details of an android: ${androidDeviceInfo.version.release}\n ${androidDeviceInfo.version.sdkInt} ");
        String details =androidDeviceInfo.version.sdkInt.toString();
        return details;
      }else{
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        log("Details of an android: ${iosDeviceInfo.systemVersion}\n ${iosDeviceInfo.systemVersion} ");
        String details =iosDeviceInfo.systemVersion.toString();
        return details;
      }
    }catch(e){
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // deviceInfo();

   
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
