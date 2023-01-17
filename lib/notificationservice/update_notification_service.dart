
  import 'dart:developer';
import 'dart:io';

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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    FlutterLocalNotificationsPlugin notificationsPlugin =FlutterLocalNotificationsPlugin();
class NewNotificationService{
NewNotificationService._();
AndroidInitializationSettings androidInitializationSettings =  const AndroidInitializationSettings("@mipmap/ic_launcher");
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
        log("Notification is : $granted");
        }
        
}

static void initializeNotific()async{
const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"),iOS: DarwinInitializationSettings(
requestAlertPermission : true,
requestSoundPermission :true,
requestBadgePermission : true,
 defaultPresentBadge : true,
 requestCriticalPermission:true,
),);
bool? initialized = await notificationsPlugin.initialize(
    initializationSettings
  );

  log("Notifications : $initialized");
}





}



