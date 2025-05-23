import 'imports/app_configuration.dart';
import 'imports/common.dart';
import 'main.dart';

void main(){
  AppEnvironments.setUpEnvironments(Environment.dev);
  mainDelegateForEnvironments();
}