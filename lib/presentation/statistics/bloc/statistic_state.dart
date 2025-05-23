part of 'statistic_bloc.dart';

@freezed
class StatisticInitialState with _$StatisticInitialState {
  const factory StatisticInitialState(
      {required bool isLoading,
      required int weeklyGoal,
      required int totalTraining,
      required int leftTrainingCount,
      required int trainingCount,
      required String monthlyTrainingTime,
      required List<DateTime> selectedDateList,
      required DateTime selectedDate,
      required List<LocalTrainings> trainingList,
      required List<LocalTrainings> totalTrainingList,
      required bool canStartTraining,
      required bool userHasSubscription,
      }) = _StatisticInitialState;

  factory StatisticInitialState.initial() => StatisticInitialState(
      isLoading: true,
      weeklyGoal: 0,
      trainingCount: 0,
      leftTrainingCount: 0,
      totalTraining: 0,
      monthlyTrainingTime: "0",
      selectedDateList: [],
      selectedDate: DateTime.now(),
      trainingList: [],
      totalTrainingList: [],
      canStartTraining: false,
      userHasSubscription: false);
}
