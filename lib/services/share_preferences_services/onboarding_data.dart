// Onboarding records
import 'package:shared_preferences/shared_preferences.dart';
import 'record_key_manager.dart';

class OnboardingData {
  final SharedPreferences _sharedPreferences;

  OnboardingData(this._sharedPreferences);

  Future<bool> isOnboardingFirstTime() async {
    return _sharedPreferences.getBool(RecordKeyManager.isOnboardingFirstTime) ??
        true;
  }

  Future<void> setOnboardingFirstTime({required bool value}) async {
    _sharedPreferences.setBool(RecordKeyManager.isOnboardingFirstTime, value);
  }
}
