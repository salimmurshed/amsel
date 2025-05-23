class CombinedIntervalData {
  final int id, selectedID;
  final int interval;
  final String germanText;
  final String englishText;
  final int audioSeconds;
  final List<num> secondsList;

  CombinedIntervalData({
    required this.id,
    this.selectedID = 0,
    required this.interval,
    required this.germanText,
    required this.englishText,
    required this.audioSeconds,
    required this.secondsList,
  });

  @override
  String toString() {
    return 'ID: $id, Interval: $interval, seconds: $audioSeconds, list: $secondsList';
  }
}