import 'dart:io';
import 'package:flutter/material.dart';
import '../functions/other.dart';

class AppStrings {
  static const String appName = "Amsel - Train your Voice";
  static const String internetStatus_foundNoConnection_error = "No Internet Connection";
  static const String routName_defaultRoute_title = 'Undefined route';
  static const String userType_undefinedUser_title = 'Undefined user';

  static const String myAccount_appSettings_selectLanguage_englishOption = "English";
  static const String myAccount_appSettings_selectLanguage_deutschOption= "Deutsch";

  //Settings URLs
  //Important App Links:
  static const String myAccount_menu_share_link = "";
  static const String myAccount_menu_facebook_link = "https://www.facebook.com/groups/918684089056065";
  static const String myAccount_menu_tips_link = "https://de.amselapp.com/tipps/";
  static const String myAccount_menu_team_link = "https://de.amselapp.com/team/";
  static const String myAccount_menu_rateUs_Androidlink = "https://play.google.com/store/apps/details?id:com.appstone.buildupyourvoice";
  static const String myAccount_menu_rateUs_Ioslink = "https://itunes.apple.com/us/app/urbanspoon/id1579286809";
  static const String myAccount_menu_teachers_link = "https://de.amselapp.com/kostenlos-fuer-lehrerinnen/";
  static const String myAccount_menu_contact_link = "info@amselapp.com";
  static const String myAccount_menu_privacy_link = "https://de.amselapp.com/impressum/";
  static const String myAccount_menu_eula_link = "https://de.amselapp.com/impressum/";

  final String monthlyPlan = Platform.isAndroid ? "premium_user" : "org.fuhs.buildyourvoice.1month";
  final String threeMonthPlan = Platform.isAndroid ? "premium_user_3_month" : "org.fuhs.buildyourvoice.3months";
  final String yearlyPlan = Platform.isAndroid ? "premium_user_12_month" : "org.fuhs.buildyourvoice.12months";

  // final List<String> subscriptionIds = <String>[
  //   AppStrings().monthlyPlan,
  //   AppStrings().threeMonthPlan,
  //   AppStrings().yearlyPlan,
  // ];

  //Training Mode Selecton
  static const String training_trainingType = "Type";
  static const String training_trainingLevel = "Level";
  static const String training_trainingRange = "Range";
  static const String training_trainingFocus = "Focus";

  //New Training Server Ids
  static const String training_type_serverId_one = "atem";
  static const String training_type_serverId_two = "sprechstimme";
  static const String training_type_serverId_three = "einsingen";
  static const String training_type_serverId_four = "verfeinern";

  static const String training_level_serverId_one = "0";
  static const String training_level_serverId_two = "1";
  static const String training_level_serverId_three = "2";
  static const String training_level_serverId_four = "3";

  static const String training_range_serverId_one = "tief";
  static const String training_range_serverId_two = "hoch";

  static const String training_focus_serverId_zero = "";
  static const String training_focus_serverId_one = "artikulator";
  static const String training_focus_serverId_two = "koerperarbeit";
  static const String training_focus_serverId_three = "resonanz";
  static const String training_focus_serverId_four = "luftgebrauch";
  static const String training_focus_serverId_five = "gelaeufigkeit";
  static const String training_focus_serverId_six = "vokalenausgleich";
  static const String training_focus_serverId_seven = "registerausgleich";
  static const String training_focus_serverId_eight = "a_vokal";
  static const String training_focus_serverId_nine = "e_vokal";
  static const String training_focus_serverId_ten = "i_vokal";
  static const String training_focus_serverId_eleven = "o_vokal";
  static const String training_focus_serverId_twelve = "u_vokal";

  //Statistic
  static const String statistic_min = "Min";

  static const String account_appInfo_appName_title = "App-Name";
  static const String account_appInfo_version_title = "App-Version";
  static const String account_appInfo_buildNumber_title = "App-BuildNumber";

  //Notification
  String free_user_notification_title = getLocale() == const Locale('de') ? "Trainingskontigent aufgefrischt" : "Training contingent refreshed";
  String free_user_notification_desc = getLocale() == const Locale('de') ? "Dein wöchentliches Trainingskontingent ist aufgefrischt worden. Los gehts." :"Your weekly training contingent has been refreshed. Let's do it!";
  String paid_user_notification_title = getLocale() == const Locale('de') ? "Erreiche dein Trainingsziel" : "Reach your training goal";
  String paid_user_notification_desc = getLocale() == const Locale('de') ? "Es gibt noch n Trainings für diese Woche zu machen, um dein Ziel zu erreichen. Los gehts!" : "There are still n workouts to do this week to reach your goal. Let's do it!";
}

class PlanIdentifiers {
  final String monthlyPlan = Platform.isAndroid ? "premium_user" : "org.fuhs.buildyourvoice.1month";
  final String threeMonthPlan = Platform.isAndroid ? "premium_user_3_month" : "org.fuhs.buildyourvoice.3months";
  final String yearlyPlan = Platform.isAndroid ? "premium_user_12_month" : "org.fuhs.buildyourvoice.12months";
}

final List<String> subscriptionIds = <String>[
  PlanIdentifiers().monthlyPlan,
  PlanIdentifiers().threeMonthPlan,
  PlanIdentifiers().yearlyPlan,
];