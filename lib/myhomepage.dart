import 'dart:developer';
import 'dart:io';

import 'package:check_notification/demo_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    deviceInfo();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New Notification");
          if (message.data['_id'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DemoScreen(
                  id: message.data['id'],
                ),
              ),
            );
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        log("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data22 ${message.data['id']}");
        }
      },
    );
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    log("Device Token Value: $deviceTokenToSendPushNotification");
  }

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
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
