part of 'weekly_goal_bloc.dart';

@freezed
class WeeklyGoalWithInitialState with _$WeeklyGoalWithInitialState {
  const factory WeeklyGoalWithInitialState({
    required int selectedGoal,
    required FixedExtentScrollController scrollController,
    required bool isUserHasSubscription,
    required bool isLoading,
}) = _WeeklyGoalWithInitialState;

  factory WeeklyGoalWithInitialState.initial() =>
      WeeklyGoalWithInitialState(
        isUserHasSubscription: false,
        scrollController: FixedExtentScrollController(),
        selectedGoal: 3,
        isLoading: true
      );
}
