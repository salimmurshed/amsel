part of 'training_bloc.dart';

@freezed
class TrainingInitialState with _$TrainingInitialState {
    const factory TrainingInitialState({
        required bool isLoading,
        required bool isFailure,
        required bool isPlaybackError,
        required Locale locale,
        required Duration totalTrainingTime,
        required bool isChallengeCompleted,
    }) = _TrainingInitialState;

    factory TrainingInitialState.initial() => TrainingInitialState(
        isLoading: true,
        isFailure: false,
        isPlaybackError: false,
        locale: getLocale(),
        totalTrainingTime: Duration.zero,
        isChallengeCompleted: false
    );
}