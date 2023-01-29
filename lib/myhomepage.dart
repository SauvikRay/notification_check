import 'dart:developer';
import 'dart:io';

import 'package:check_notification/model/push_notification.dart';
import 'package:check_notification/notifiaction_badge.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

import 'networks/send_fcm_token.dart';
import 'notificationservice/update_notification_service.dart';

FirebaseMessaging  messaging= FirebaseMessaging.instance;



DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter=0;
  String deviceTokenToSendPushNotification = '';
 
  PushNotification? _notificationdetails;
 
    void requestAndRegisterNotification()async{
      //instance Firebase Messaging;


      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized){
        log("Notification Permission is Accessed");
   


        String? token = await messaging.getToken();
        log("The token is :" + token!);
          postFcmToken(token);

        // FirebaseMessaging.onMessage.listen(( message) {
        //   PushNotification notification =PushNotification(message.notification?.title, message.notification?.body);

        //   setState(() {
        //     _notificationdetails = notification;
        //     _counter++;
        //   });
        //       if(_notificationdetails != null){
        //         //Displaying Noti
        //         // showSimpleNotification(
        //         //   Text(_notificationdetails!.title!),
        //         //   leading: NotificationBadge(totalNoti: _counter),
        //         //   subtitle: Text(_notificationdetails!.body!),
        //         //   background: Colors.cyan.shade700,
        //         //   duration:const Duration(seconds: 2),
        //         // );
               
        //       }

        //  });

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New Notification");
          if (message.data['id'] != null) {

            log("Firebase Message : Go to new page");
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DemoScreen(
            //       id: message.data['id'],
            //     ),
            //   ),
            // );
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data}");
          NewNotificationService.createAndDisplaynotification(message);
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
    


    }
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

    requestAndRegisterNotification();
 

   
  }

   Future< void> showNotification()async{

    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        "checknotification",
        "newchannel", 
        icon:"@mipmap/ic_launcher",

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
      child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          SizedBox(height: 5,),
          NotificationBadge(totalNoti: _counter),
          SizedBox(height: 5,),
          _notificationdetails !=null? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title : ${_notificationdetails!.title!}'),
                   const SizedBox(height: 5,),
                     Text("Body :${_notificationdetails!.body!} "),
            ],
          ): Container()
        ],
      ),
    );
  }
}
