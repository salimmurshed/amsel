// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import '../main.dart';
//
// FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// // THIS FUNCTION ASYNCHRONOUSLY RETRIEVES BOTH THE FCM AND APN TOKENS, INTRODUCING A SHORT DELAY BETWEEN THEM, AND RETURNS THE FCM TOKEN ONCE IT'S RETRIEVED.
// retrieveFcmApnsTokens() async {
//   String? fcmToken = await messaging.getToken();
//   // debugPrint("FCM Token: $fcmToken");
//
//   // await Clipboard.setData(ClipboardData(text: fcmToken!));
//
//   // DELAY FOR 3 SECONDS BEFORE RETRIEVING APN TOKEN
//   await Future.delayed(const Duration(seconds: 3));
//
// // THIS LINE ASYNCHRONOUSLY RETRIEVES THE APN (Apple Push Notification) TOKEN
// // USING THE getAPNSToken METHOD OF THE FirebaseMessaging.instance OBJECT.
// // THE AWAIT KEYWORD ENSURES THAT THE CODE WAITS FOR THE APN TOKEN TO BE RETRIEVED BEFORE PROCEEDING.
// // THE TOKEN IS STORED IN THE VARIABLE apnToken, WHICH IS DECLARED AS A NULLABLE STRING.
//
//   String? apnToken = await FirebaseMessaging.instance.getAPNSToken();
//   // debugPrint("APN Token: $apnToken");
//
//   return fcmToken;
// }
//
// class FirebaseCloudMessage {
//   late FirebaseMessaging fcm;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late NotificationSettings settings;
//
//   Future setUpNotificationServiceForOS({required isCalledFromBg}) async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var ios = const DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//     var initializationSetting = InitializationSettings(
//       android: android,
//       iOS: ios,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: onSelectNotification);
//
//     if (!isCalledFromBg) {
//       await configureFCM();
//     }
//   }
//
//   onSelectNotification(NotificationResponse notificationResponse) async {
//     var payloadData = jsonDecode(notificationResponse.payload!);
//     // debugPrint("payload $payloadData");
//   }
//
//   Future showNotification(title, notification, payload) async {
//     /*Creating channel for notifications*/
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'amsel_fcm_channel', 'amsel_fcm_channel',
//         description: 'This channel is used for Amsel App',
//         importance: Importance.high,
//         showBadge: true,
//         enableVibration: true,
//         playSound: true);
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     var android = const AndroidNotificationDetails(
//       'amsel_fcm_channel',
//       'amsel_fcm_channel',
//       channelDescription: 'This channel is used for amsel App',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       enableLights: true,
//       ticker: 'ticker',
//     );
//     var ios = const DarwinNotificationDetails(
//         presentAlert: true,
//         presentSound: true,
//         presentBadge: true,
//         presentBanner: true,
//         presentList: true);
//     var platformSpecifics = NotificationDetails(
//       android: android,
//       iOS: ios,
//     );
//     Random random = Random();
//     int uniqueNumber = random.nextInt(1000);
//     // debugPrint("object number is $uniqueNumber");
//
//     var load = jsonDecode(payload);
//     // debugPrint("payload is $load");
//
//     await flutterLocalNotificationsPlugin.show(
//         uniqueNumber, '$title', '$notification', platformSpecifics,
//         payload: payload);
//   }
//
//   configureFCM() async {
//     fcm = FirebaseMessaging.instance;
//     settings = await fcm.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (kDebugMode) {
//       // debugPrint('User granted permission');
//     }
//
//     // sendNotificationEveryMinute();
//     await scheduleRepeatingNotification();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       // debugPrint("received notification1 ${message.toMap()}");
//       // debugPrint("received notification ${message.notification!.toMap()}");
//       // debugPrint("toast message is here ${message.data}");
//       showNotification('${message.notification!.title}',
//           '${message.notification!.body}', jsonEncode(message.data));
//     });
//
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) async {
//       // debugPrint("onMessageOpenedApp ${message.toMap()}");
//       // debugPrint("onMessageOpenedApp notification value is ${message.data}");
//     });
//   }
//
//   void sendNotificationEveryMinute() async {
//     // for (int i = 0; i < 60; i++) {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'amsel_fcm_channel', 'amsel_fcm_channel',
//         description: 'This channel is used for Amsel App',
//         importance: Importance.high,
//         showBadge: true,
//         enableVibration: true,
//         playSound: true);
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     var android = const AndroidNotificationDetails(
//       'amsel_fcm_channel',
//       'amsel_fcm_channel',
//       channelDescription: 'This channel is used for amsel App',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       enableLights: true,
//       ticker: 'ticker',
//     );
//     var ios = const DarwinNotificationDetails(
//         presentAlert: true,
//         presentSound: true,
//         presentBadge: true,
//         presentBanner: true,
//         presentList: true);
//     var platformSpecifics = NotificationDetails(
//       android: android,
//       iOS: ios,
//     );
//     await flutterLocalNotificationsPlugin.show(0, 'Minute Notification',
//         'This is a notification scheduled for every minute.', platformSpecifics,
//         payload: 'This is a payload');
//     // }
//   }
//
//   Future<void> scheduleRepeatingNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'repeating channel id', 'repeating channel name',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//         0,
//         'Repeating Notification',
//         'This notification repeats every minute',
//         RepeatInterval.everyMinute,
//         platformChannelSpecifics,
//         androidAllowWhileIdle: true);
//   }
// }
