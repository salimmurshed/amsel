import '../resources/validation_regex.dart';

bool isEmailValid(String email){
  return emailRegex.hasMatch(email);
}
