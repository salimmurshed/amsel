import 'dart:io';
import 'package:amsel_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../data/model/local_models/training_details.dart';
import '../../data/repository/repository_dependencies.dart';
import '../../imports/common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Locale getLocale() {
  Locale currentLocale = WidgetsBinding.instance.platformDispatcher.locale;
  // debugPrint("currentLocale: ${currentLocale.languageCode}");
  if (currentLocale.languageCode == 'de') {
    return const Locale('de');
  } else {
    return const Locale('en');
  }
}

openBrowserFromUrl({required String url}) async {
  debugPrint("url is $url");
  if (Platform.isAndroid) {
    await launchUrlString(url, mode: LaunchMode.externalNonBrowserApplication);
  } else {
    await launchUrl(Uri.parse(url));
  }
}

openEmailFromUrl({required String email, String? subject}) async {
  String emailValue = Uri.encodeComponent(email);
  String subjectValue = Uri.encodeComponent(subject ?? "");
  Uri mail = Uri.parse("mailto:$emailValue?subject=$subjectValue");
  if (await launchUrl(mail)) {
    debugPrint("email app opened");
  } else {
    debugPrint("email app is not opened");
  }
}

String formatDuration(double seconds) {
  int minutes = seconds ~/ 60;
  return minutes.toString().padLeft(2, '0');
}

String formatDurationWithMinAndSec(Duration durationValue) {
  Duration duration = durationValue;

  // Convert to mm:ss format
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  String minSec = "$minutes:$seconds";
  // debugPrint("MinSec: $minSec"); // Output: 00:41
  return minSec;
}

class GetDashboardSelectedData {
  static Future<String> getTypeValue() async {
    String type = await RepositoryDependencies.trainingData.geTrainingType();
    // debugPrint("type is $type");
    int index = DashboardDetailsData.typeList
        .indexWhere((element) => element.serverTitle == type);
    // debugPrint("index is $index");
    type = DashboardDetailsData.typeList[index].title;
    return type;
  }

  static Future<String> getLevelValue() async {
    String level = await RepositoryDependencies.trainingData.getTrainingLevel();
    int index = DashboardDetailsData.levelList
        .indexWhere((element) => element.serverTitle == level);
    level = DashboardDetailsData.levelList[index].title;
    return level;
  }

  static Future<String> getRangeValue() async {
    String range = await RepositoryDependencies.trainingData.getTrainingRange();
    // debugPrint("range is $range");
    int index = DashboardDetailsData.rangeList
        .indexWhere((element) => element.serverTitle == range);
    // debugPrint("index is $index");
    range = DashboardDetailsData.rangeList[index].title;
    return range;
  }

  static Future<String> getFocusValue({bool isForFavourite = false}) async {
    String focus = await RepositoryDependencies.trainingData.getTrainingFocus();
    // debugPrint("focus is $focus");
    if (focus.contains(",")) {
      focus.replaceAll(" ", "");
      List<String> list = focus.split(",");
      // debugPrint("focus list is $list");
      if (isForFavourite) {
        List<DashboardMenuModel> focusList = [];
        List<DashboardMenuModel> focusFilteredList = [];
        focusList.addAll(DashboardDetailsData.focusList);
        focusFilteredList = focusList
            .where((element) => list.contains(element.serverTitle))
            .toList();
        List<String> finalFocusList = [];
        for (int i = 0; i < focusFilteredList.length; i++) {
          finalFocusList.add(focusFilteredList[i].title);
        }
        // debugPrint("focus at dash is $finalFocusList");
        focus = finalFocusList.toList().toString().replaceAll("[", "").replaceAll("]", "");
        // debugPrint("focus at dash is $focus");
      } else {
        focus = "${list.length} ${AppLocalizations.of(navigatorKey.currentContext!)!.training_focus_selected}";
      }
    } else {
      int index = DashboardDetailsData.focusList.indexWhere((element) => element.serverTitle == focus);
      if (index >= 0) {
        focus = DashboardDetailsData.focusList[index].title;
      } else {
        focus = "";
      }
    }
    return focus;
  }
}

double getSpeed({required Speed speed}) {
  switch (speed) {
    case Speed.normal:
      return 1.0;
    case Speed.fast:
      return 1.1;
    case Speed.veryFast:
      return 1.2;
    case Speed.verySlow:
      return 0.8;
    case Speed.slow:
      return 0.9;
  }
}

// Duration subscriptionDuration({required String productId}) {
//   if(productId == AppStrings().threeMonthPlan){
//     return const Duration(days: 90); // 3 months
//   } else if(productId == AppStrings().yearlyPlan){
//     return const Duration(days: 365); // 1 year
//   } else {
//     return const Duration(minutes: 30); // 1 month
//   }
// }

DateTime getEstimatedExpiryDate(String productId, DateTime purchaseDate) {
  debugPrint("productId: $productId date $purchaseDate");
  if(productId == AppStrings().threeMonthPlan){
    // return DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day, purchaseDate.hour, purchaseDate.minute + 10, purchaseDate.second); // 3 months
    return DateTime(purchaseDate.year, purchaseDate.month + 3, purchaseDate.day, purchaseDate.hour, purchaseDate.minute, purchaseDate.second); // 3 months
  } else if(productId == AppStrings().yearlyPlan){
    // return DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day, purchaseDate.hour, purchaseDate.minute + 15, purchaseDate.second); // 1 year
    return DateTime(purchaseDate.year + 1, purchaseDate.month, purchaseDate.day, purchaseDate.hour, purchaseDate.minute, purchaseDate.second); // 1 year
  } else {
    return DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day, purchaseDate.hour, purchaseDate.minute + 5, purchaseDate.second); // 1 month
    // return DateTime(purchaseDate.year, purchaseDate.month + 1, purchaseDate.day, purchaseDate.hour, purchaseDate.minute, purchaseDate.second); // 1 month
  }
}

Future<File> getLocalImageFile(String assetPath) async {
  // Load the asset as ByteData
  final ByteData data = await rootBundle.load(assetPath);
  // Convert ByteData to List<int>
  final Uint8List bytes = data.buffer.asUint8List();
  // Get the temporary directory
  final Directory tempDir = await getTemporaryDirectory();
  // Create a File in the temporary directory
  final File file = File('${tempDir.path}/temp_image.png');
  // Write the bytes to the file
  await file.writeAsBytes(bytes);
  return file;
}

String convertToMinutes(Duration duration) {
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds % 60;
  double result = minutes + (seconds / 60);
  debugPrint("result is $result and round ${result.toStringAsFixed(2)} minutes: $minutes seconds: $seconds");
  // return result.toStringAsFixed(2);
  String time = "$minutes:$seconds";
  return time;
}