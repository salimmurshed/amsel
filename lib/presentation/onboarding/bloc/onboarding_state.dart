part of 'onboarding_bloc.dart';

@freezed
class OnboardingInitialState with _$OnboardingInitialState {
  const factory OnboardingInitialState({
    required int currentIndex,
    required bool isLast,
    required List<Widget> introPageList
  }) = _OnboardingInitialState;

  factory OnboardingInitialState.initial() =>
       const OnboardingInitialState(
        currentIndex: 0,
          isLast: false,
          introPageList: [
            IntroPageOne(

            ),
            IntroPageTwo(

            ),
            IntroPageThree(

            ),
            IntroPageFour(

            ),
            IntroPageFive(

            ),
          ]
      );
}
