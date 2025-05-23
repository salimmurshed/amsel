import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../widget/intro_page_five.dart';
import '../widget/intro_page_four.dart';
import '../widget/intro_page_one.dart';
import '../widget/intro_page_three.dart';
import '../widget/intro_page_two.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';
part 'onboarding_bloc.freezed.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingInitialState> {
  OnboardingBloc() : super(OnboardingInitialState.initial()) {
    on<OnBoardPageControllerUpdate>(_onBoardPageControllerUpdate);
    on<TriggerOnBoardPageNextPage>(_onTriggerOnBoardPageNextPage);
  }

  FutureOr<void> _onBoardPageControllerUpdate(OnBoardPageControllerUpdate event, Emitter<OnboardingInitialState> emit) {
    int currentIndex = event.currentIndex;
    event.pageController.addListener(() {
      event.pageController.page?.round() ?? 0;
    });
    // debugPrint("current page is $currentIndex");
    bool isLastPage = event.currentIndex == 4 ? true : false;
    emit(state.copyWith(isLast: isLastPage, currentIndex: currentIndex));
  }

  FutureOr<void> _onTriggerOnBoardPageNextPage(TriggerOnBoardPageNextPage event, Emitter<OnboardingInitialState> emit) async {
    int currentIndex = state.currentIndex;
    bool isLastPage = state.currentIndex == 4 ? true : false;

    if(state.currentIndex < 4) {
      currentIndex++;
      event.pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }
    // if (state.currentIndex < 2 && state.currentIndex != -1) {
    //   event.pageController.nextPage(
    //       duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    // } else if (state.currentIndex == -1) {
    //
    // } else {
      emit(state.copyWith(isLast: isLastPage, currentIndex: currentIndex));

    // }
  }
}