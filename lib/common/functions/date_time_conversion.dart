import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:intl/intl.dart';
import '../../data/model/local_models/local_trainings.dart';
import '../../data/repository/local_products_repository.dart';
import '../../imports/common.dart';

String extractDateOnlyFromDateTime(DateTime dateTime) {
  String formattedTime = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedTime;
}

String extractDateOnlyFromDateTimeInDotFormat(DateTime dateTime) {
  String formattedTime = DateFormat('dd.MM.yyyy').format(dateTime);
  return formattedTime;
}

String extractTimeOnlyFromDateTime(DateTime dateTime) {
  String formattedTime = DateFormat.Hm().format(dateTime);
  return formattedTime;
}

String formatTimeDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours:$minutes:$seconds';
}

DateTime convertStringToDateTime({required String date}) {
  RegExp dateRegex = RegExp(
      r'^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}(\.\d{1,3})?Z)?$');
  return dateRegex.hasMatch(date) ? DateTime.parse(date) : DateTime.now();
}

String convertDateTimeToString(
    {required DateTime dateTime, required DateTimeFormatForApiResponse format}) {
  switch (format) {
    case DateTimeFormatForApiResponse.utc:
      return dateTime.toUtc()
          .toIso8601String(); // Format: "2023-02-04T00:00:00.000Z"
    case DateTimeFormatForApiResponse.nonUtc:
      return "${dateTime.year}-${dateTime.month.toString().padLeft(
          2, '0')}-${dateTime.day.toString().padLeft(
          2, '0')}"; // Format: "2023-05-05"
    default:
      throw ArgumentError("Invalid format specified");
  }
}

String convertSecondsToTime({required int duration}) {
  int minutes = duration ~/ 60;
  int seconds = duration % 60;

  // Formatting minutes and seconds to always have two digits
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}

String convertSecondsToMinute({required int duration}) {
  int minutes = duration ~/ 60;

  // Formatting minutes and seconds to always have two digits
  String minutesStr = minutes.toString().padLeft(2, '0');

  return '$minutesStr Minutes';
}

String notificationTimeStamp(String timeStr) {
  DateTime givenTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(timeStr);
  DateTime currentTime = DateTime.now();
  Duration timeDifference = currentTime.difference(givenTime);

  if (timeDifference < const Duration(hours: 12)) {
    int minutesDiff = timeDifference.inMinutes;
    if (minutesDiff < 60 && minutesDiff > 0) {
      return "$minutesDiff mins ago";
    } else if (minutesDiff == 0) {
      return "Just now";
    }
    else {
      int hoursDiff = (minutesDiff / 60).floor();
      return "$hoursDiff hrs ago";
    }
  } else {
    return DateFormat("hh:mm a MM/dd/yyyy").format(givenTime);
  }
}

Map<String, DateTime> getCurrentWeek() {
  // Get the current date
  DateTime now = DateTime.now();

  // Find the start of the week (assuming the week starts on Monday)
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

  // Find the end of the week
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

  return {
    'startOfWeek': startOfWeek,
    'endOfWeek': endOfWeek,
  };
}

Future<int> getTrainingsThisWeek() async {
  // Determine the start and end of the current week
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));
  List<LocalTrainings> totalTrainings =
  await LocalTrainingRepository.fetchProducts();
  // Filter trainings to include only those within the current week
  final trainingsThisWeek = totalTrainings.where((training) {
    final trainingDate = DateTime(training.date.year, training.date.month, training.date.day);
    return trainingDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        trainingDate.isBefore(endOfWeek.add(const Duration(days: 1)));
  }).toList();
  await RepositoryDependencies.appSettingsData.setLeftTrainingCount(value: trainingsThisWeek.length);
  int leftTrainingCount = await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
  // debugPrint("left training count is $leftTrainingCount");
  return leftTrainingCount;
}

getUTCTime({required String expiryDate}){
  String dateTimeWithoutTimeZone = expiryDate.substring(0, 19);
  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime utcDate = format.parseUtc(dateTimeWithoutTimeZone);
  return utcDate;
}