import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_setting_handler.dart';

part 'app_setting_event.dart';

part 'app_setting_state.dart';

part 'app_setting_bloc.freezed.dart';


class AppSettingBloc extends Bloc<AppSettingEvent, AppSettingWithInitialState> {
  AppSettingBloc() : super(AppSettingWithInitialState.initial()) {
    on<TriggerFetchActivatedSwitches>(_onTriggerFetchActivatedSwitches);
    on<TriggerNotificationPermissionEvent>(
        _onEnableDisableNotificationEvent);
  }

  FutureOr<void> _onEnableDisableNotificationEvent(
      TriggerNotificationPermissionEvent event,
      Emitter<AppSettingWithInitialState> emit) async {
    await handleNotificationPermissions(
        emit: emit,
        event: event,
        state: state);
  }

  Future<void> handleNotificationPermissions({
    required TriggerNotificationPermissionEvent event,
    required Emitter<AppSettingWithInitialState> emit,
    required AppSettingWithInitialState state,
  }) async {
    emit(state.copyWith(isLoading: true));
    bool isPushNotificationActive = await handleNotificationPermission();
    emit(state.copyWith(
      isLoading: false,
      isPushNotificationActive: isPushNotificationActive,
    ));
  }


  FutureOr<void> _onTriggerFetchActivatedSwitches(
      TriggerFetchActivatedSwitches event,
      Emitter<AppSettingWithInitialState> emit) async {
    await handleActivatedToggleButtonStateRetrieval(
      event: event,
      emit: emit,
      state: state,
    );
  }
}
