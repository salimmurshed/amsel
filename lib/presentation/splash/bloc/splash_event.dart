part of 'splash_bloc.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();
  @override
  List<Object?> get props => [];
}

class TriggerSplashScreenOpen extends SplashEvent{}

class TriggerNavigation extends SplashEvent{}