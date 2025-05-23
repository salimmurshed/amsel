part of 'contact_us_bloc.dart';

@freezed
class ContactUsWithInitialState with _$ContactUsWithInitialState {
  const factory ContactUsWithInitialState({
    required String message,
    required bool isFailure,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController companyController,
    required TextEditingController newsController,
    required FocusNode firsNameFocusNode,
    required FocusNode lastNameFocusNode,
    required FocusNode emailFocusNode,
    required FocusNode companyFocusNode,
    required FocusNode newsFocusNode,
    required bool isFirstNameInvalid,
    required bool isLastNameInvalid,
    required bool isEmailInvalid,
    required bool isNewsInvalid,
    required bool isLoading,
    required int textLength,
  }) = _ContactUsWithInitialState;

  factory ContactUsWithInitialState.initial() => ContactUsWithInitialState(
      message: '',
      isFailure: false,
      isLoading: false,
      firstNameController: TextEditingController(),
      lastNameController: TextEditingController(),
      companyController: TextEditingController(),
      emailController: TextEditingController(),
      newsController: TextEditingController(),
      firsNameFocusNode: FocusNode(),
      lastNameFocusNode: FocusNode(),
      companyFocusNode: FocusNode(),
      emailFocusNode: FocusNode(),
      newsFocusNode: FocusNode(),
      isFirstNameInvalid: false,
      isLastNameInvalid: false,
      isEmailInvalid: false,
      isNewsInvalid: false,
      textLength: 0,
  );
}