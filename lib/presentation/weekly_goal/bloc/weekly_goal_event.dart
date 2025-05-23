part of 'weekly_goal_bloc.dart';

sealed class WeeklyGoalEvent extends Equatable {
  const WeeklyGoalEvent();
  @override
  List<Object?> get props => [];
}

class FetchSubscriptionDetails extends WeeklyGoalEvent{}

class TriggerScrollController extends WeeklyGoalEvent{}

class TriggerGoalSelection extends WeeklyGoalEvent{
  final int goal;
  final bool isFinal;
  const TriggerGoalSelection({required this.goal, this.isFinal = false});
}
