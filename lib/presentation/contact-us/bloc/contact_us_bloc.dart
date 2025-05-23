import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/functions/text_field_validations.dart';
import '../usecase/contact_us_usecase.dart';
import 'contact_us_handlers.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';
part 'contact_us_bloc.freezed.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsWithInitialState> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ContactUsUseCase contactUsUseCase;
  ContactUsBloc(this.contactUsUseCase) : super(ContactUsWithInitialState.initial()) {
    on<TriggerContactUs>(_onTriggerContactUs);
    on<TriggerContactUsFirstNameCheck>(_onTriggerContactUsFirstNameCheck);
    on<TriggerContactUsPageRefresh>(_onTriggerContactUsPageRefresh);
    on<TriggerContactUsLastNameCheck>(_onTriggerContactUsLastNameCheck);
    on<TriggerOnChangeContactUs>(_onTriggerOnChangeContactUs);
    on<TriggerContactUsEmailCheck>(_onTriggerContactUsEmailCheck);
    on<TriggerContactUsMessageCheck>(_onTriggerContactUsMessageCheck);
    on<TriggerContactUsFormValidationCheck>(_onTriggerContactUsMobileNumberCheck);
    on<TriggerCharLengthCheck>(_onTriggerCharLengthCheck);
  }


  FutureOr<void> _onTriggerContactUs(
      TriggerContactUs event, Emitter<ContactUsWithInitialState> emit) async {
    if (formKey.currentState!.validate()) {
      await handleContactUsSubmitButtonEvent(
        event: event,
        emit: emit,
        state: state,
        contactUsUseCase: contactUsUseCase,
      );
    }
  }

  FutureOr<void> _onTriggerContactUsFirstNameCheck(
      TriggerContactUsFirstNameCheck event,
      Emitter<ContactUsWithInitialState> emit) {
    handleContactUsNameCheck(isFirstName: true, name: event.firstName, emit: emit, state: state);
  }

  FutureOr<void> _onTriggerContactUsLastNameCheck(
      TriggerContactUsLastNameCheck event,
      Emitter<ContactUsWithInitialState> emit) {
    handleContactUsNameCheck(isFirstName: false, name: event.lastName, emit: emit, state: state);
  }

  FutureOr<void> _onTriggerContactUsMessageCheck(
      TriggerContactUsMessageCheck event,
      Emitter<ContactUsWithInitialState> emit) {
    String? validationResult =
    validateNews(event.message.trim().toLowerCase());
    emit(state.copyWith(
        message: '',
        isFailure: false,
        isNewsInvalid: validationResult == null ? false : true));
  }

  FutureOr<void> _onTriggerContactUsEmailCheck(TriggerContactUsEmailCheck event,
      Emitter<ContactUsWithInitialState> emit) {
    String? validationResult = validateEmail(event.email.trim().toLowerCase());
    emit(state.copyWith(
        message: '',
        isFailure: false,
        isEmailInvalid: validationResult == null ? false : true));
  }

  FutureOr<void> _onTriggerContactUsPageRefresh(
      TriggerContactUsPageRefresh event,
      Emitter<ContactUsWithInitialState> emit) {
    formKey = GlobalKey<FormState>();
    emit(ContactUsWithInitialState.initial());
  }


  FutureOr<void> _onTriggerContactUsMobileNumberCheck(
      TriggerContactUsFormValidationCheck event,
      Emitter<ContactUsWithInitialState> emit) {
    emit(state.copyWith(
      message: '',
      isFailure: false,
    ));
    if (formKey.currentState!.validate()) {
     // debugPrint("ready to go");
      add(TriggerContactUs(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        company: event.company,
        news: event.news,
      ));
    } else {
      formKey.currentState!.validate();
      emit(
        state.copyWith(
          message: '',
          isFailure: false,
        ),
      );
    }
  }

  FutureOr<void> _onTriggerOnChangeContactUs(TriggerOnChangeContactUs event, Emitter<ContactUsWithInitialState> emit) {
    emit(
      state.copyWith(
        newsController: event.newsController,
          isFailure: false),
    );
  }

  FutureOr<void> _onTriggerCharLengthCheck(TriggerCharLengthCheck event, Emitter<ContactUsWithInitialState> emit) async {
    emit(state.copyWith(textLength: event.news.length));
  }
}