part of 'navigators_bloc.dart';

@immutable
abstract class NavigatorsEvent extends Equatable {
  const NavigatorsEvent();
  @override
  List<Object?> get props => [];
}

class TriggerNavigatorsButton extends NavigatorsEvent {
  final int currentIndex;
  const TriggerNavigatorsButton(
      {required this.currentIndex});
  @override
  List<Object?> get props => [currentIndex];
}

