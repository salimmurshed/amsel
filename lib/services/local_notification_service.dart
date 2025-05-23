// import 'dart:convert';
// import 'package:amsel_flutter/common/functions/other.dart';
// import 'package:amsel_flutter/common/resources/app_strings.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
// import 'package:amsel_flutter/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize() async {
//     // Initialize time zone
//     // tz.initializeTimeZones();
//
//     // Android Initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS Initialization
//     final DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
//         // Handle notification tapped logic here
//       },
//     );
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (id) async {
//         // Handle notification tapped logic here
//       },
//     );
//   }
//
//   onSelectNotification(NotificationResponse notificationResponse) async {
//     var payloadData = jsonDecode(notificationResponse.payload!);
//     // debugPrint("payload $payloadData");
//   }
//   // static Future<void> scheduleRepeatingNotification() async {
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //   AndroidNotificationDetails(
//   //     'repeating_channel_id', // Must match the channel created
//   //     'Repeating Notifications',
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //     ticker: 'ticker',
//   //   );
//   //
//   //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//   //     android: androidPlatformChannelSpecifics,
//   //   );
//   //
//   //   bool isUserHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
//   //   debugPrint("isUserHasSubscription $isUserHasSubscription");
//   //   // if(isUserHasSubscription){
//   //   //
//   //   // } else {
//   //   //   await flutterLocalNotificationsPlugin.periodicallyShow(
//   //   //     1, // Notification ID
//   //   //     'Repeating Notification',
//   //   //     'This notification repeats every minute.',
//   //   //     RepeatInterval.weekly, // Supported intervals: Minute, Hour, Day, etc.
//   //   //     platformChannelSpecifics,
//   //   //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //   //   );
//   //   // }
//   //
//   //   // Schedule repeating notification
//   //   await flutterLocalNotificationsPlugin.periodicallyShow(
//   //     1, // Notification ID
//   //     'Repeating Notification',
//   //     'This notification repeats every minute.',
//   //     RepeatInterval.everyMinute, // Supported intervals: Minute, Hour, Day, etc.
//   //     platformChannelSpecifics,
//   //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //   );
//   // }
//
//
//   // scheduleWeeklyNotification() async {
//   //   // Define the time you want the notification to appear
//   //
//   //   TimeOfDay now = TimeOfDay.now();
//   //
//   //   print("Current Time: ${now.format(navigatorKey.currentContext!)}"); // Requires a BuildContext
//   //   print("Hour: ${now.hour}, Minute: ${now.minute}");
//   //
//   //   TimeOfDay notificationTime = const TimeOfDay(hour: 15, minute: 38); // 9:00 AM
//   //
//   //   // Get the next Monday's date
//   //   tz.TZDateTime nextMondayDate = _nextInstanceOfMonday(notificationTime);
//   //
//   //   debugPrint("nextMondayDate $nextMondayDate");
//   //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   //   AndroidNotificationDetails(
//   //     'weekly_channel_id',
//   //     'Weekly Notifications',
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //   );
//   //
//   //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//   //     android: androidPlatformChannelSpecifics,
//   //   );
//   //
//   //   tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));
//   //
//   //   debugPrint("scheduledDate $scheduledDate");
//   //
//   //   await flutterLocalNotificationsPlugin.periodicallyShow(
//   //     0,
//   //     AppLocalizations.of(navigatorKey.currentContext!)!.free_user_notification_title,
//   //     AppLocalizations.of(navigatorKey.currentContext!)!.free_user_notification_desc,
//   //     // scheduledDate,
//   //     RepeatInterval.weekly,
//   //     platformChannelSpecifics,
//   //     androidAllowWhileIdle: true,
//   //     // uiLocalNotificationDateInterpretation:
//   //     // UILocalNotificationDateInterpretation.absoluteTime,
//   //     // matchDateTimeComponents: DateTimeComponents.dateAndTime,
//   //   );
//   // }
//   //
//   // tz.TZDateTime _nextInstanceOfMonday(TimeOfDay time) {
//   //   tz.TZDateTime scheduledDate = _nextInstanceOfWeekday(time, DateTime.tuesday);
//   //
//   //   // If the scheduled date is before the current time, schedule it for next week
//   //   if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//   //     scheduledDate = scheduledDate.add(const Duration(days: 7));
//   //   }
//   //   return scheduledDate;
//   // }
//   //
//   // tz.TZDateTime _nextInstanceOfWeekday(TimeOfDay time, int weekday) {
//   //   tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   //   tz.TZDateTime scheduledDate = tz.TZDateTime(
//   //     tz.local,
//   //     now.year,
//   //     now.month,
//   //     now.day,
//   //     time.hour,
//   //     time.minute,
//   //   );
//   //   debugPrint("scheduledDate0  $scheduledDate");
//   //   // Adjust the scheduled date to the next occurrence of the specified weekday
//   //   while (scheduledDate.weekday != weekday) {
//   //     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   //   }
//   //   debugPrint("scheduledDate $scheduledDate");
//   //   return scheduledDate;
//   // }
//
//   static Future<void> showSimpleNotification({required bool isForPaidUser}) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'simple_channel_id',
//       'Simple Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     // debugPrint("Get local ${getLocale()}");
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       isForPaidUser ? AppStrings().paid_user_notification_title: AppStrings().free_user_notification_title,
//       isForPaidUser ? AppStrings().paid_user_notification_desc: AppStrings().free_user_notification_desc,
//       platformChannelSpecifics,
//     );
//   }
//
// }
