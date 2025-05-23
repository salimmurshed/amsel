part of 'training_bloc.dart';

sealed class TrainingEvent extends Equatable {
  const TrainingEvent();
  @override
  List<Object?> get props => [];
}

class FetchTrainingDetailEvent extends TrainingEvent{}

class TriggerPlayerCompleted extends TrainingEvent {}

class TriggerChallengeDone extends TrainingEvent {}

class TriggerRepeatChallenge extends TrainingEvent {}