import 'package:isar/isar.dart';
//this line is needed to generate file
//then run the command in terminal: dart run build_runner build delete-conflicting-outputs
part 'local_trainings.g.dart';
@Collection()
class LocalTrainings{
  Id id = Isar.autoIncrement;
  late DateTime date;
  late String duration;
  late String type;
  late String level;
  late String range;
  late String focus;
  late String typeServerId;
  late String levelServerId;
  late String rangeServerId;
  late String focusServerId;
  late int totalTrainingTime;
  late int totalAttendedTrainingTime;
}