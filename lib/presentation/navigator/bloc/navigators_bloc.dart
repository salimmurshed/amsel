import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigators_event.dart';

part 'navigators_state.dart';

part 'navigators_bloc.freezed.dart';

class NavigatorsBloc
    extends Bloc<NavigatorsEvent, NavigatorStateWithInitialState> {

  NavigatorsBloc()
      : super(NavigatorStateWithInitialState.initial()) {
    on<TriggerNavigatorsButton>(_onNavigatorsEventTriggerButton);

  }

  FutureOr<void> _onNavigatorsEventTriggerButton(TriggerNavigatorsButton event,
      Emitter<NavigatorStateWithInitialState> emit) {
    emit(NavigatorStateWithInitialState(currentIndex: event.currentIndex));
  }

}
