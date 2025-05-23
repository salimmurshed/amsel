part of 'app_setting_bloc.dart';

@freezed
class AppSettingWithInitialState with _$AppSettingWithInitialState {
  const factory AppSettingWithInitialState({
    required bool isPushNotificationActive,
      required String appName,
      required String appBuildVersion,
      required String appBuildNumber,
      required bool isRefresh,
      required bool isLoading
      }) = _AppSettingWithInitialState;

  factory AppSettingWithInitialState.initial() =>
      const AppSettingWithInitialState(
        isPushNotificationActive: false,
        isRefresh: false,
        isLoading: true,
        appName: '',
        appBuildVersion: '',
        appBuildNumber: '',
      );
}
