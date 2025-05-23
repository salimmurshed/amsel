import 'dart:io';

import 'common/resources/enum.dart';

/*
  iosUrl needs id which is something you will get from apple developer console
  androidUrl need id which is something you will get from app/build.gradle at applicationId com.vitec.bloc_template.prod
 */
final Uri iosUrl = Uri.parse('https://itunes.apple.com/us/app/urbanspoon/id6463011653');
final Uri androidUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.vitec.bloc_template.prod');

class DeviceVariables{
  static String deviceType = Platform.isAndroid ? OS.android.name : OS.ios.name;
  static Uri urlLauncher =  Platform.isAndroid ? androidUrl : iosUrl;
}