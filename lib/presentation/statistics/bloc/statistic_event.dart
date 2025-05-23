part of 'statistic_bloc.dart';

sealed class StatisticEvent extends Equatable {
  const StatisticEvent();
  @override
  List<Object?> get props => [];
}

class FetchTrainingListEvent extends StatisticEvent{}

class TriggerResetGoalEvent extends StatisticEvent{}

class FetchSelectedDateTrainingList extends StatisticEvent {
  final DateTime date;
  const FetchSelectedDateTrainingList({required this.date});
}
class FetchSelectedMonthTrainingList extends StatisticEvent {
  final DateTime date;
  const FetchSelectedMonthTrainingList({required this.date});
}

class TriggerRemoveTrainingEvent extends StatisticEvent {
  final int trainingId;
  const TriggerRemoveTrainingEvent({required this.trainingId});
}

class TriggerRepeatTrainingEvent extends StatisticEvent{
  final LocalTrainings localTrainings;
  const TriggerRepeatTrainingEvent({required this.localTrainings});
}

