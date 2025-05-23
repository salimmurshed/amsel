import 'package:amsel_flutter/presentation/app_settings/bloc/app_setting_bloc.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notification_permissions/notification_permissions.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../main.dart';

class PushNotificationView extends StatefulWidget {
  const PushNotificationView({super.key});

  @override
  State<PushNotificationView> createState() => _PushNotificationViewState();
}

class _PushNotificationViewState extends State<PushNotificationView>
    with WidgetsBindingObserver {
  final AppSettingBloc settingBloc = instance<AppSettingBloc>();

  @override
  void initState() {
    super.initState();
    // _accountBloc.add(TriggerFetchActivatedSwitches());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      settingBloc.add(TriggerNotificationPermissionEvent());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingBloc, AppSettingWithInitialState>(
        bloc: settingBloc..add(TriggerFetchActivatedSwitches()),
        listener: (context, state) {
      WidgetsBinding.instance.addObserver(this);
    }, builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(

          title:
              AppLocalizations.of(context)!.setting_menu_notification_part_two,
        ),
        body: Stack(
          children: [
            Container(),
            const Positioned(
                bottom: -50,
                right: 0,
                child: ImageView(
                  imagePath: Assets.icBottomBG,
                )),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHPadding, vertical: screenVPadding),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text:'${ AppLocalizations.of(context)!.setting_menu_notification_part_one}-',
                            style: Style.subHeaderStyle()),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .setting_menu_notification_part_two,
                          style: Style.subHeaderStyle(
                              colorBG: AppColor.colorPrimaryBG),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: widgetBottomPadding),
                  Text(AppLocalizations.of(context)!.push_notification_desc,
                      style: Style.descTextStyle()),
                  SizedBox(height: screenVPadding),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),

                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColor.colorSecondaryText, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${AppLocalizations.of(context)!.setting_menu_notification_part_one}-${AppLocalizations.of(context)!.setting_menu_notification_part_two}',
                          style: isTablet? Style.infoTextStyle(): null,
                        ),
                        Transform.scale(
                          scaleX: isTablet? 1.5:1,
                          scaleY: isTablet? 1.5:1,
                          child: Container(
                            margin: EdgeInsets.only(bottom: isTablet? 8.h: 0),
                            child: CustomCupertinoToggleButton(

                              trackColor: AppColor.colorLightGrey,
                              onChanged: (value) {
                                  AppSettings.openAppSettings(
                                      type: AppSettingsType.notification);
                                  NotificationPermissions
                                      .requestNotificationPermissions(
                                          iosSettings:
                                              const NotificationSettingsIos(
                                                  sound: true,
                                                  badge: true,
                                                  alert: true));
                              },
                              isToggled: state.isPushNotificationActive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
