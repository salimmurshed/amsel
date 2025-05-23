import 'package:amsel_flutter/common/functions/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';

String? validateFirstName(String value) {
  if(value.isEmpty){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addFirstName_emptyField_error;
  } else if(value.length > 20){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addFirstName_tooLarge_error;
  }else if(value.length < 4){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addFirstName_tooSmall_error;
  }else {
    return null;
  }
}

String? validateLastName(String value) {
  if(value.isEmpty){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addLastName_emptyField_error;
  } else if(value.length > 20){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addLastName_tooLarge_error;
  }else if(value.length < 4){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addLastName_tooSmall_error;
  }else {
    return null;
  }
}

String? validateEmail(String value) {
  if(value.isEmpty){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addEmail_emptyField_error;
  } else if(!isEmailValid(value)) {
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addEmail_invalid_error;
  } else {
    return null;
  }
}

String? validateNews(String value) {
  if(value.isEmpty){
    return AppLocalizations.of(navigatorKey.currentContext!)!.textfield_addNews_emptyField_error;
  } else {
    return null;
  }
}

