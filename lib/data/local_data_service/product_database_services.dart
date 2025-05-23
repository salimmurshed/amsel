import 'package:isar/isar.dart';
import '../../services/isar_db_services/isar_db_instance/isar_helpers.dart';
import '../model/local_models/favourite_trainings.dart';
import '../model/local_models/local_trainings.dart';
/*
We are using repository pattern to separate the data layer from the business logic layer.
If we wish to change the data source in the future, we can do so without affecting the business logic layer.
If we don't want ISAR DB we can used the same functions with another data source like SQLite, Hive, etc.
 */
class TrainingDataBaseSource {
  /// C R E A T E - add a product and save to db
  Future<void> addTraining({
    required DateTime date,
    required String duration,
    required String type,
    required String level,
    required String range,
    required String focus,
    required String typeServerId,
    required String levelServerId,
    required String rangeServerId,
    required String focusServerId,
    required int totalTrainingTime,
    required int totalAttendedTrainingTime,
  }) async {
    final training = LocalTrainings()
      ..date = date
      ..duration = duration
      ..type = type
      ..level = level
      ..range = range
      ..focus = focus
      ..typeServerId = typeServerId
      ..levelServerId = levelServerId
      ..rangeServerId = rangeServerId
      ..focusServerId = focusServerId
      ..totalTrainingTime = totalTrainingTime
      ..totalAttendedTrainingTime = totalAttendedTrainingTime;
    await IsarHelpers.isar
        .writeTxn(() => IsarHelpers.isar.localTrainings.put(training));
  }

  /// R E A D - get all products from db
  Future<List<LocalTrainings>> fetchTrainings() async {
    List<LocalTrainings> trainings =
        await IsarHelpers.isar.localTrainings.where().findAll();
    return trainings;
  }

  Future<void> deleteProduct({required int trainingId}) async {
    await IsarHelpers.isar
        .writeTxn(() => IsarHelpers.isar.localTrainings.delete(trainingId));
  }

  Future<void> addFavouriteTraining({
    required DateTime date,
    required double duration,
    required String title,
    required String type,
    required String level,
    required String range,
    required String focus,
    required String typeServerId,
    required String levelServerId,
    required String rangeServerId,
    required String focusServerId,
  }) async {
    final trainings = FavouriteTrainings()
      ..date = date
      ..duration = duration
      ..title = title
      ..type = type
      ..level = level
      ..range = range
      ..focus = focus
      ..typeServerId = typeServerId
      ..levelServerId = levelServerId
      ..rangeServerId = rangeServerId
      ..focusServerId = focusServerId;
    await IsarHelpers.isar
        .writeTxn(() => IsarHelpers.isar.favouriteTrainings.put(trainings));
  }

  /// R E A D - get all products from db
  Future<List<FavouriteTrainings>> fetchFavTrainings() async {
    List<FavouriteTrainings> products =
    await IsarHelpers.isar.favouriteTrainings.where().findAll();
    return products;
  }
  /// D E L E T E - delete a product from db
  Future<void> deleteFavProduct({required int trainingId}) async {
    await IsarHelpers.isar
        .writeTxn(() => IsarHelpers.isar.favouriteTrainings.delete(trainingId));
  }
}
