
import 'package:shared_preferences/shared_preferences.dart';
import 'record_key_manager.dart';

class AppSettingsData {
  final SharedPreferences _sharedPreferences;

  AppSettingsData(this._sharedPreferences);

  //Crashlytics
  Future<bool> isCrashCollectionActive() async {
    return _sharedPreferences
            .getBool(RecordKeyManager.isCrashCollectionActive) ??
        true;
  }

  Future<void> setCrashlyticsCollectionPermission({required bool value}) async {
    _sharedPreferences.setBool(RecordKeyManager.isCrashCollectionActive, value);
  }

  //Notification
  Future<bool> isPushNotificationActive() async {
    return _sharedPreferences
            .getBool(RecordKeyManager.isPushNotificationActive) ??
        true;
  }

  Future<void> setNotificationPermission({required bool value}) async {
    _sharedPreferences.setBool(
        RecordKeyManager.isPushNotificationActive, value);
  }

  Future<bool> isUserHasSubscription() async {
    return _sharedPreferences.getBool(RecordKeyManager.isUserHasSubscription) ??
        false;
  }

  Future<void> setSubscriptionHasSubscription({required bool value}) async {
    _sharedPreferences.setBool(RecordKeyManager.isUserHasSubscription, value);
  }

  //set User subscription data
  Future<void> setUserSubscription({required String jsonEncodedValue}) async {
    _sharedPreferences.setString(RecordKeyManager.userSubscription, jsonEncodedValue);
  }

  //User subscription extensive detail-- use jsonEncode to transform to string when setting value
  Future<String?> getUserSubscription() async {
    return _sharedPreferences.getString(RecordKeyManager.userSubscription);
  }

  Future<int> getTrainingCount() async {
    return _sharedPreferences.getInt(RecordKeyManager.trainingCount) ?? 3;
  }

  Future<void> setTrainingCount({required int value}) async {
    _sharedPreferences.setInt(RecordKeyManager.trainingCount, value);
  }

  Future<int> getLeftTrainingCount() async {
    return _sharedPreferences.getInt(RecordKeyManager.leftTrainingCount) ?? 0;
  }

  Future<void> setLeftTrainingCount({required int value}) async {
    _sharedPreferences.setInt(RecordKeyManager.leftTrainingCount, value);
  }
  Future<void> setTrainingCountReset({required String value}) async {
    _sharedPreferences.setString(RecordKeyManager.resetTrainingCountDate, value);
  }

  Future<String?> getTrainingCountRest() async {
    return _sharedPreferences.getString(RecordKeyManager.resetTrainingCountDate);
  }

}
