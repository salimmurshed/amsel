import '../../di/di.dart';
import '../local_data_service/product_database_services.dart';
import '../model/local_models/favourite_trainings.dart';
import '../model/local_models/local_trainings.dart';

class LocalTrainingRepository {
  TrainingDataBaseSource localDataSource = instance<TrainingDataBaseSource>();

  static Future<List<LocalTrainings>> addTraining({
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
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    await localProductsRepository.localDataSource.addTraining(
        date: date,
        duration: duration,
        type: type,
        level: level,
        range: range,
        focus: focus,
        typeServerId: typeServerId,
        levelServerId: levelServerId,
        rangeServerId: rangeServerId,
        focusServerId: focusServerId,
        totalTrainingTime: totalTrainingTime,
        totalAttendedTrainingTime: totalAttendedTrainingTime);
    return await LocalTrainingRepository.fetchProducts();
  }

  static Future<List<LocalTrainings>> deleteLocalProduct(
      {required int trainingId}) async {
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    await localProductsRepository.localDataSource
        .deleteProduct(trainingId: trainingId);
    return await LocalTrainingRepository.fetchProducts();
  }

  static Future<List<LocalTrainings>> fetchProducts() async {
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    return await localProductsRepository.localDataSource.fetchTrainings();
  }

  static Future<void> addFavouriteProduct({
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
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    await localProductsRepository.localDataSource.addFavouriteTraining(
        date: date,
        duration: duration,
        title: title,
        type: type,
        level: level,
        range: range,
        focus: focus,
        typeServerId: typeServerId,
        levelServerId: levelServerId,
        rangeServerId: rangeServerId,
        focusServerId: focusServerId);
  }

  static Future<List<FavouriteTrainings>> fetchFavouriteProducts() async {
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    return await localProductsRepository.localDataSource.fetchFavTrainings();
  }

  static Future<List<LocalTrainings>> deleteFavouriteProduct(
      {required int trainingId}) async {
    LocalTrainingRepository localProductsRepository = LocalTrainingRepository();
    await localProductsRepository.localDataSource
        .deleteFavProduct(trainingId: trainingId);
    return await LocalTrainingRepository.fetchProducts();
  }
}