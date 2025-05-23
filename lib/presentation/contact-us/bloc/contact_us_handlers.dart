import 'package:bloc/bloc.dart';
import '../../../common/functions/text_field_validations.dart';
import '../../../data/model/api_request_models/contact_us_request_model.dart';
import '../../../data/model/api_response_models/common_response_model.dart';
import '../../../imports/common.dart';
import '../usecase/contact_us_usecase.dart';
import 'contact_us_bloc.dart';

Future<void> handleContactUsSubmitButtonEvent({
  required TriggerContactUs event,
  required Emitter<ContactUsWithInitialState> emit,
  required ContactUsUseCase contactUsUseCase,
  required ContactUsWithInitialState state,
}) async {
  emit(state.copyWith(message: '', isFailure: false, isLoading: true));
  try {
    final response = await contactUsUseCase.execute(ContactUsRequestModel(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      news: event.news,
      company: event.company,
    ));
    response.fold(
      (failure) =>
          _handleContactUsFailure(failure: failure, emit: emit, state: state),
      (success) =>
          _handleContactUsSuccess(success: success, emit: emit, state: state),
    );
  } catch (e) {
    emit(state.copyWith(
        message: e.toString(), isFailure: true, isLoading: false));
  }
}

_handleContactUsSuccess(
    {required CommonResponseModel success,
    required Emitter<ContactUsWithInitialState> emit,
    required ContactUsWithInitialState state}) {
  emit(state.copyWith(
      message: success.message!, isFailure: false, isLoading: false));
}

_handleContactUsFailure(
    {required Failure failure,
    required Emitter<ContactUsWithInitialState> emit,
    required ContactUsWithInitialState state}) {
  emit(state.copyWith(
      message: failure.message, isFailure: true, isLoading: false));
}

handleContactUsNameCheck(
    {required String name,
    required Emitter<ContactUsWithInitialState> emit,
      required bool isFirstName,
    required ContactUsWithInitialState state}) {
  emit(state.copyWith(
      message: '',
      isFailure: false,
  ));
  String? validationResult = isFirstName
      ? validateFirstName(name.trim().toLowerCase())
      :  validateLastName(name.trim().toLowerCase());

  if(isFirstName) {
    emit(state.copyWith(
      isFirstNameInvalid: validationResult == null ? false : true));
  }else {
    emit(state.copyWith(
      isLastNameInvalid: validationResult == null ? false : true));
  }

}
bool shouldTriggerContactUsEvent({required TriggerContactUsFormValidationCheck event, }){
  return event.isFirstNameValid &&
      event.isLastNameValid &&
      event.isEmailValid &&
      event.isNewsValid;
}