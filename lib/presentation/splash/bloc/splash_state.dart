part of 'splash_bloc.dart';

@freezed
class SplashInitialState with _$SplashInitialState {
  const factory SplashInitialState({
    required bool isDelayCompleted,
  }) = _SplashInitialState;

  factory SplashInitialState.initial() => const SplashInitialState(
      isDelayCompleted: false
  );
}
