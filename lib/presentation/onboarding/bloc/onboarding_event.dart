part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class OnBoardPageControllerUpdate extends OnboardingEvent {
  final PageController pageController;
  final int currentIndex;
  const OnBoardPageControllerUpdate({
    required this.pageController,
    required this.currentIndex,
  });
  @override
  List<Object?> get props => [pageController, currentIndex];
}

class TriggerOnBoardPageNextPage extends OnboardingEvent {
  final PageController pageController;
  const TriggerOnBoardPageNextPage({
    required this.pageController,
  });
  @override
  List<Object?> get props => [pageController];
}
