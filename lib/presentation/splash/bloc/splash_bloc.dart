import 'dart:async';
import 'package:amsel_flutter/presentation/splash/bloc/splash_handlers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_event.dart';
part 'splash_state.dart';
part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashInitialState> {
  SplashBloc() : super(SplashInitialState.initial()) {
    on<TriggerSplashScreenOpen>(_onTriggerSplashScreenOpen);
  }

  FutureOr<void> _onTriggerSplashScreenOpen(
      TriggerSplashScreenOpen event, Emitter<SplashInitialState> emit) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      emit(state.copyWith(isDelayCompleted: true));
      await handleNavigation();
    });
  }
}