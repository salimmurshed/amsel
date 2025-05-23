import 'dart:async';
import 'package:amsel_flutter/common/widgets/toast.dart';
import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:amsel_flutter/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'weekly_goal_event.dart';
part 'weekly_goal_state.dart';
part 'weekly_goal_bloc.freezed.dart';

class WeeklyGoalBloc extends Bloc<WeeklyGoalEvent, WeeklyGoalWithInitialState> {
  WeeklyGoalBloc() : super(WeeklyGoalWithInitialState.initial()) {
    on<FetchSubscriptionDetails>(_onFetchSubscriptionDetails);
    on<TriggerGoalSelection>(_onTriggerGoalSelection);
    on<TriggerScrollController>(_onTriggerScrollController);
  }

  FutureOr<void> _onFetchSubscriptionDetails(FetchSubscriptionDetails event, Emitter<WeeklyGoalWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    bool isUserHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    int goal = await RepositoryDependencies.appSettingsData.getTrainingCount();
    // debugPrint("free goal is $goal");
    emit(state.copyWith(isUserHasSubscription: isUserHasSubscription, selectedGoal: goal, isLoading: false,
      scrollController: FixedExtentScrollController(initialItem: goal - 3)
    ));
  }

  FutureOr<void> _onTriggerGoalSelection(TriggerGoalSelection event, Emitter<WeeklyGoalWithInitialState> emit) async {
    int currentIndex = state.scrollController.selectedItem;
    if(event.isFinal){
      currentIndex = currentIndex + 3;
      await RepositoryDependencies.appSettingsData.setTrainingCount(value: currentIndex);
      Toast.nullableIconToast(message: AppLocalizations.of(navigatorKey.currentContext!)!.weekly_goal_change_success, isErrorBooleanOrNull: false);
      Navigator.pop(navigatorKey.currentContext!, true);
    }
    emit(state.copyWith(selectedGoal: currentIndex));
  }

  FutureOr<void> _onTriggerScrollController(TriggerScrollController event, Emitter<WeeklyGoalWithInitialState> emit) {
    int currentIndex = state.scrollController.selectedItem;
    if (currentIndex < 96) { // Ensure we don't exceed the list bounds
      state.scrollController.animateToItem(
        currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    emit(state.copyWith(selectedGoal: currentIndex));
  }
}