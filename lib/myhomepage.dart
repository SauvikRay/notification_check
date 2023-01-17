import 'dart:developer';
import 'dart:io';

import 'package:check_notification/demo_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';
import 'notificationservice/notification-service.dart';
import 'notificationservice/update_notification_service.dart';

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
        log("Details of an android: ${androidDeviceInfo.version.release} ${androidDeviceInfo.version.sdkInt} ");
        String details =androidDeviceInfo.version.sdkInt.toString();
        return details;
      }else{
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        log("Details of an ios: ${iosDeviceInfo.systemVersion} ${iosDeviceInfo.systemVersion} ");
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
    deviceInfo();
 

   
  }

   Future< void> showNotification()async{

    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        "newchannel", 
        "checknotification",
        // icon: 

        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        );

    DarwinNotificationDetails iOSNotificationDetails = const DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentSound: true);
     NotificationDetails notiDetails = NotificationDetails(android: androidDetails,iOS: iOSNotificationDetails);
   await  notificationsPlugin.show(1, "New test title", "Total body", notiDetails,payload: "Details");
    }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Notification'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showNotification();
      },
      child: Icon(Icons.add),
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
