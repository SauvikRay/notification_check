
  import 'dart:developer';
import 'dart:io';

import 'package:check_notification/myhomepage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//From Flutter Local Notification
  @pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

  int id = 0;

    FlutterLocalNotificationsPlugin notificationsPlugin =FlutterLocalNotificationsPlugin();
class NewNotificationService{
NewNotificationService._();
AndroidInitializationSettings androidInitializationSettings =  const AndroidInitializationSettings('@mipmap/ic_launcher');
DarwinInitializationSettings? iosSettings = const DarwinInitializationSettings(
requestAlertPermission : true,
requestSoundPermission :true,
requestBadgePermission : true,
 defaultPresentBadge : true,
 requestCriticalPermission:true,
);


static void  requestNotiPermission()async{
        if(Platform.isIOS){
          await notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true,badge: true,sound: true);
        }else if(Platform.isAndroid){
          final AndroidFlutterLocalNotificationsPlugin? androidImplementation = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        final bool? granted = await androidImplementation?.requestPermission();
        log("Notification is granted: $granted");
        }
        
}

static void initializeNotification()async{
const InitializationSettings initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
iOS: DarwinInitializationSettings(
requestAlertPermission : true,
requestSoundPermission :true,
requestBadgePermission : true,
 defaultPresentBadge : true,
 defaultPresentSound:true,
 requestCriticalPermission:true,
),);
bool? initialized = await notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    onDidReceiveNotificationResponse: (notificationResponse) async{
        final String? payload = notificationResponse.payload;
        if(notificationResponse.payload !=null){
          debugPrint("Notification Payload: $payload");
        }
       //Here go to new route with notification.
    },
  );

  log("Notifications : $initialized");
}

static void createAndDisplaynotification(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'checknotification',
          'pushnotificationappchannel',
          icon:'@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          

        ),

        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound:true,
          
        ),
      );

      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }




}



