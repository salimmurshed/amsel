part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchTrainingDetails extends DashboardEvent {}

class TriggerResetGoalEvent extends DashboardEvent {}

class TriggerSliderUpdate extends DashboardEvent {
  final double seconds;
  const TriggerSliderUpdate({required this.seconds});
}

class FetchTrainingTypeLevelRangeList extends DashboardEvent {
  final String selectedMode;
  const FetchTrainingTypeLevelRangeList({required this.selectedMode});
}

class TriggerTypeLevelRangeSelection extends DashboardEvent {
  final DashboardMenuModel item;
  final String selectedMode;
  const TriggerTypeLevelRangeSelection({required this.item, required this.selectedMode});
}

class FetchFocusList extends DashboardEvent {}

class FetchFavouriteTrainingList extends DashboardEvent {}

class TriggerFocusSelection extends DashboardEvent {
  final DashboardMenuModel item;
  const TriggerFocusSelection({required this.item});
}

class TriggerControllerOnChangedEvent extends DashboardEvent {
  final TextEditingController textEditingController;
  const TriggerControllerOnChangedEvent({required this.textEditingController});
}

class TriggerAddToFavouriteTrainingEvent extends DashboardEvent {}

class TriggerRemoveFromFavouriteEvent extends DashboardEvent {
  final int trainingId;
  const TriggerRemoveFromFavouriteEvent({required this.trainingId});
}

class TriggerToSetFavouriteTrainingDataEvent extends DashboardEvent {
  final FavouriteTrainings trainingId;
  const TriggerToSetFavouriteTrainingDataEvent({required this.trainingId});
}

class TriggerRefresh extends DashboardEvent {}



