//getInitialDelay
Duration getInitialDelay({bool isForPaidUser = false}) {
  final now = DateTime.now();
  final nextDay = now.add(Duration(days: (isForPaidUser ? DateTime.thursday: DateTime.monday - now.weekday + 7) % 7));
  final scheduledTime = DateTime(nextDay.year, nextDay.month, nextDay.day, 8, 0);
  final initialDelay = scheduledTime.isAfter(now)
      ? scheduledTime.difference(now)
      : Duration.zero;
  return initialDelay;
}

Future<void> cancelAllTasks() async {
  // await Workmanager().cancelAll();
}