part of 'contact_us_bloc.dart';

abstract class ContactUsEvent extends Equatable {
  const ContactUsEvent();

  @override
  List<Object?> get props => [];
}

class TriggerRequestFocusForTextFieldWithChar extends ContactUsEvent {
  final bool hasFocus;
  final bool? isPhone;

  const TriggerRequestFocusForTextFieldWithChar(
      {required this.hasFocus, required this.isPhone});

  @override
  List<Object?> get props => [hasFocus, isPhone];
}

class TriggerContactUs extends ContactUsEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String news;
  final String? company;

  const TriggerContactUs({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.news,
    this.company,
  });

  @override
  List<Object?> get props =>
      [firstName, lastName, email, news, company];
}

class TriggerContactUsPageRefresh extends ContactUsEvent {}

class TriggerContactUsFirstNameCheck extends ContactUsEvent {
  final String firstName;
  const TriggerContactUsFirstNameCheck({required this.firstName});

  @override
  List<Object?> get props => [firstName];
}

class TriggerOnChangeContactUs extends ContactUsEvent {
  final TextEditingController newsController;

  const TriggerOnChangeContactUs(
      {required this.newsController});

  @override
  List<Object?> get props => [newsController];
}

class TriggerContactUsLastNameCheck extends ContactUsEvent {
  final String lastName;

  const TriggerContactUsLastNameCheck({required this.lastName});

  @override
  List<Object?> get props => [lastName];
}

class TriggerContactUsFormValidationCheck extends ContactUsEvent {
  final bool isEmailValid;
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isNewsValid;
  final String firstName;
  final String lastName;
  final String email;
  final String news;
  final String company;


  const TriggerContactUsFormValidationCheck({
    required this.isEmailValid,
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isNewsValid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.news,
    required this.company,
  });

  @override
  List<Object?> get props => [
    isEmailValid, isFirstNameValid, isLastNameValid, isNewsValid,
    firstName, lastName, email, news, company,
  ];
}

class TriggerContactUsEmailCheck extends ContactUsEvent {
  final String email;

  const TriggerContactUsEmailCheck({required this.email});

  @override
  List<Object?> get props => [email];
}

class TriggerContactUsMessageCheck extends ContactUsEvent {
  final String message;

  const TriggerContactUsMessageCheck({required this.message});

  @override
  List<Object?> get props => [message];
}

class TriggerCharLengthCheck extends ContactUsEvent {
  final String news;

  const TriggerCharLengthCheck({required this.news});

  @override
  List<Object?> get props => [news];
}