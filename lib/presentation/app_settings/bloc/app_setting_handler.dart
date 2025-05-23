
// handle notification permission
import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:bloc/bloc.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_setting_bloc.dart';

Future<bool> handleNotificationPermission() async {
  PermissionStatus status =
  await NotificationPermissions.getNotificationPermissionStatus();
  bool isPushNotificationActive;

  if (status == PermissionStatus.granted) {
    isPushNotificationActive = true;
  } else {
    isPushNotificationActive = false;
  }

  await RepositoryDependencies.appSettingsData.setNotificationPermission(value: isPushNotificationActive);

  return isPushNotificationActive;
}

// handle active switch retrieval
Future<void> handleActivatedToggleButtonStateRetrieval(
    {required TriggerFetchActivatedSwitches event,
      required Emitter<AppSettingWithInitialState> emit,
      required AppSettingWithInitialState state,
    }) async {
  // debugPrint("here at active switichius");
  bool isPushNotificationActive =
  await RepositoryDependencies.appSettingsData.isPushNotificationActive();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = packageInfo.appName ?? '';
  String appBuildVersion = packageInfo.version ?? '';
  String appBuildNumber = packageInfo.buildNumber ?? '';
  emit(state.copyWith(
    appName: appName,
    appBuildNumber: appBuildNumber,
    appBuildVersion: appBuildVersion,
    isPushNotificationActive: isPushNotificationActive,
    isLoading: false,
  ));
}
