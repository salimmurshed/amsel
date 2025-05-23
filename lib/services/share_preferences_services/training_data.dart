import 'package:shared_preferences/shared_preferences.dart';

import 'record_key_manager.dart';

class TrainingData {
  final SharedPreferences _sharedPreferences;

  TrainingData(this._sharedPreferences);

  Future<String?> getMinute() async {
    return _sharedPreferences.getString(RecordKeyManager.minute);
  }

  Future<void> setMinute({required String value}) async {
    _sharedPreferences.setString(RecordKeyManager.minute, value);
  }

  Future<String> geTrainingType() async {
    return _sharedPreferences.getString(RecordKeyManager.type) ?? "";
  }

  Future<void> seTrainingType({required String type}) async {
    _sharedPreferences.setString(RecordKeyManager.type, type);
  }

  Future<void> setTrainingLevel({required String level}) async {
    _sharedPreferences.setString(RecordKeyManager.level, level);
  }

  Future<String> getTrainingLevel() async {
    return _sharedPreferences.getString(RecordKeyManager.level) ?? "";
  }

  Future<void> setTrainingRange({required String range}) async {
    _sharedPreferences.setString(RecordKeyManager.range, range);
  }

  Future<String> getTrainingRange() async {
    return _sharedPreferences.getString(RecordKeyManager.range) ?? "";
  }

  Future<void> setTrainingFocus({required String focus}) async {
    _sharedPreferences.setString(RecordKeyManager.focus, focus);
  }

  Future<String> getTrainingFocus() async {
    return _sharedPreferences.getString(RecordKeyManager.focus) ?? "";
  }

  //Check User has subscription
  // Future<bool> isUserHasSubscription() async {
  //   return _sharedPreferences.getBool(RecordKeyManager.isUserHasSubscription) ?? false;
  // }
  //
  // Future<void> setUserHasSubscription({required bool value}) async {
  //   _sharedPreferences.setBool(RecordKeyManager.isUserHasSubscription, value);
  // }

  // //set Free Training Count data
  // Future<void> setFreeTrainingCount({required int value}) async {
  //   _sharedPreferences.setInt(RecordKeyManager.feeTrainingCount, value);
  // }
  //
  // //User subscription extensive detail-- use jsonEncode to transform to string when setting value
  // Future<int> getFreeTrainingCount() async {
  //   return _sharedPreferences.getInt(RecordKeyManager.feeTrainingCount) ?? 0;
  // }

}
