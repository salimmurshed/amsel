import 'dart:async';
import 'package:amsel_flutter/common/resources/training_constants.dart';
import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../common/functions/date_time_conversion.dart';
import '../../../common/functions/other.dart';
import '../../../data/model/local_models/local_trainings.dart';
import '../../../data/repository/local_products_repository.dart';

part 'statistic_event.dart';

part 'statistic_state.dart';

part 'statistic_bloc.freezed.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticInitialState> {
  StatisticBloc() : super(StatisticInitialState.initial()) {
    on<FetchTrainingListEvent>(_onFetchTrainingListEvent);
    on<FetchSelectedDateTrainingList>(_onFetchSelectedDateTrainingList);
    on<TriggerRemoveTrainingEvent>(_onTriggerRemoveTrainingEvent);
    on<TriggerRepeatTrainingEvent>(_onTriggerRepeatTrainingEvent);
    on<TriggerResetGoalEvent>(_onTriggerResetGoalEvent);
    // on<FetchSelectedMonthTrainingList>(_onFetchSelectedMonthTrainingList);
  }

  FutureOr<void> _onFetchTrainingListEvent(FetchTrainingListEvent event, Emitter<StatisticInitialState> emit) async {
    emit(StatisticInitialState.initial());
    List<LocalTrainings> totalTrainings =
        await LocalTrainingRepository.fetchProducts();
    List<LocalTrainings> localProducts = [];
    localProducts.addAll(totalTrainings);
    // Map<String, dynamic> trainingStats = calculateTrainingStats(localProducts);
    // Map<String, Map<String, int>> monthlyStats = trainingStats['monthlyStats'];
    // double averageOfMonthlyTotals = trainingStats['averageOfMonthlyTotals'];
    // monthlyStats.forEach((monthYear, stats) {
    //   debugPrint('Month: $monthYear, Total Time: ${stats['totalTime']} mins, Average Time: ${stats['averageTime']} mins');
    // });
    // String monthlyTraining = convertToMinutes(Duration(seconds: averageOfMonthlyTotals.toInt()));

    // Step 1: Calculate the average time for each month
    Map<int, double> monthlyAverages = calculateAverageTrainingTimePerMonth(localProducts);
    print('monthly Average: $monthlyAverages condition ${monthlyAverages.isEmpty}');

    // Step 2: Calculate the overall average of these monthly averages
    double overallAverage = calculateOverallAverageOfMonthlyAverages(monthlyAverages);
    print('Overall Average: $overallAverage minutes');

    // Print the result
    print('Overall Average of Monthly Averages: ${overallAverage.toStringAsFixed(2)} minutes');
    String monthlyTraining = convertToMinutes(Duration(seconds: monthlyAverages.isEmpty ? 0 : overallAverage.round()));
    List<DateTime> selectedDates = [];
    for (var element in localProducts) {
      selectedDates.add(element.date);
    }
    int totalTraining = 0;

    if (localProducts.isNotEmpty) {
      localProducts.where((data) {
        return data.date.month == DateTime.now().month &&
            data.date.year == DateTime.now().year;
      }).toList();
      totalTraining = localProducts.length;
      localProducts.removeWhere((element) {
        return extractDateOnlyFromDateTime(element.date) !=
            extractDateOnlyFromDateTime(DateTime.now());
      });
      localProducts.sort((b, a) => a.date.compareTo(b.date));
      // debugPrint("product length $localProducts with date ${DateTime.now()}");
    }
    int leftTrainingCount = await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
    int trainingCount = await RepositoryDependencies.appSettingsData.getTrainingCount();
    bool userHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();

    // debugPrint("today's product length ${selectedDates.toList().toString()}");
    emit(state.copyWith(
        isLoading: false,
        trainingList: localProducts,
        totalTrainingList: totalTrainings,
        trainingCount: trainingCount,
        leftTrainingCount: leftTrainingCount,
        totalTraining: totalTraining,
        monthlyTrainingTime: monthlyTraining,
        selectedDateList: selectedDates,
        userHasSubscription: userHasSubscription));
  }

  FutureOr<void> _onFetchSelectedDateTrainingList(FetchSelectedDateTrainingList event, Emitter<StatisticInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<LocalTrainings> localProducts =
        await LocalTrainingRepository.fetchProducts();
    if (localProducts.isNotEmpty) {
      localProducts.removeWhere((element) {
        // debugPrint("selected ${event.date}, focus ${element.date}");
        return extractDateOnlyFromDateTime(element.date) !=
            extractDateOnlyFromDateTime(event.date);
      });
      // debugPrint("product length $localProducts with date ${event.date} ");
      localProducts.sort((b, a) => a.date.compareTo(b.date));
    }
    emit(state.copyWith(
        isLoading: false,
        trainingList: localProducts,
        selectedDate: event.date));
  }

  FutureOr<void> _onTriggerRemoveTrainingEvent(TriggerRemoveTrainingEvent event, Emitter<StatisticInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    await LocalTrainingRepository.deleteLocalProduct(
        trainingId: event.trainingId);
    List<LocalTrainings> localProducts =
        await LocalTrainingRepository.fetchProducts();
    emit(state.copyWith(
        isLoading: false,
        trainingList: localProducts,
        totalTrainingList: localProducts));
  }

  FutureOr<void> _onTriggerRepeatTrainingEvent(TriggerRepeatTrainingEvent event, Emitter<StatisticInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    await RepositoryDependencies.trainingData
        .seTrainingType(type: event.localTrainings.typeServerId);
    await RepositoryDependencies.trainingData
        .setTrainingLevel(level: event.localTrainings.levelServerId);
    await RepositoryDependencies.trainingData
        .setTrainingRange(range: event.localTrainings.rangeServerId);
    await RepositoryDependencies.trainingData
        .setTrainingFocus(focus: event.localTrainings.focusServerId);
    TrainingConstants.durationSeconds =
        double.parse(event.localTrainings.duration);
    emit(state.copyWith(isLoading: false, canStartTraining: true));
  }

  FutureOr<void> _onTriggerResetGoalEvent(
      TriggerResetGoalEvent event, Emitter<StatisticInitialState> emit) async {
    int count = await RepositoryDependencies.appSettingsData.getTrainingCount();
    emit(state.copyWith(trainingCount: count));
  }

  Map<String, dynamic> calculateTrainingStats(List<LocalTrainings> trainings) {
    // Group trainings by month and year
    Map<String, List<LocalTrainings>> groupedByMonth = {};

    for (var training in trainings) {
      String monthYear = DateFormat('yyyy-MM').format(training.date);
      if (!groupedByMonth.containsKey(monthYear)) {
        groupedByMonth[monthYear] = [];
      }
      groupedByMonth[monthYear]!.add(training);
    }

    // Calculate total and average time per month
    Map<String, Map<String, int>> monthlyStats = {};
    int sumOfMonthlyTotals = 0;

    groupedByMonth.forEach((monthYear, trainingList) {
      int totalTime = trainingList.fold(0, (sum, training) => sum + training.totalTrainingTime);
      int averageTime = totalTime ~/ trainingList.length;

      monthlyStats[monthYear] = {
        'totalTime': totalTime,
        'averageTime': averageTime,
      };

      sumOfMonthlyTotals += totalTime;
    });

    // Calculate the average value of all monthly total times
    double averageOfMonthlyTotals = groupedByMonth.isNotEmpty
        ? sumOfMonthlyTotals / groupedByMonth.length
        : 0.0;

    return {
      'monthlyStats': monthlyStats,
      'averageOfMonthlyTotals': averageOfMonthlyTotals,
    };
  }

  Map<int, double> calculateAverageTrainingTimePerMonth(List<LocalTrainings> trainings) {
    // Map to hold the total time and count of trainings per month
    Map<int, int> totalTimes = {};
    Map<int, int> counts = {};

    // Iterate through the list and group by month
    for (var training in trainings) {
      int month = training.date.month;

      // Initialize the month in the maps if it doesn't exist
      if (!totalTimes.containsKey(month)) {
        totalTimes[month] = 0;
        counts[month] = 0;
      }

      // Accumulate the total time and count for each month
      totalTimes[month] = totalTimes[month]! + training.totalAttendedTrainingTime;
      counts[month] = counts[month]! + 1;
    }

    // Map to hold the average time per month
    Map<int, double> averageTimes = {};

    // Calculate the average time for each month
    totalTimes.forEach((month, totalTime) {
      averageTimes[month] = totalTime / counts[month]!;
    });

    return averageTimes;
  }
  double calculateOverallAverageOfMonthlyAverages(Map<int, double> monthlyAverages) {
    double totalAverage = 0;
    int monthCount = monthlyAverages.length;

    // Sum all monthly averages
    monthlyAverages.forEach((month, averageTime) {
      totalAverage += averageTime;
    });

    // Calculate the overall average
    return totalAverage / monthCount;
  }

}
