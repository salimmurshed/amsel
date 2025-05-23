import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../bloc/app_setting_bloc.dart';

class AppInformationView extends StatefulWidget {
  const AppInformationView({super.key});

  @override
  State<AppInformationView> createState() => _AppInformationViewState();
}

class _AppInformationViewState extends State<AppInformationView> {
  final AppSettingBloc settingBloc = instance<AppSettingBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${AppLocalizations.of(context)!
            .setting_menu_appInfo_partOne}${AppLocalizations.of(context)!
            .setting_menu_appInfo_partTwo}',
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
          BlocConsumer<AppSettingBloc, AppSettingWithInitialState>(
              bloc: settingBloc..add(TriggerFetchActivatedSwitches()),
              listener: (context, state) {},
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHPadding, vertical: screenVPadding),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!.setting_menu_appInfo_partOne,
                                style: Style.subHeaderStyle()),
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .setting_menu_appInfo_partTwo,
                              style: Style.subHeaderStyle(
                                  colorBG: AppColor.colorPrimaryBG),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: widgetBottomPadding),
                      Text(AppLocalizations.of(context)!.app_info_desc, style: Style.descTextStyle()),
                      SizedBox(height: screenVPadding),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.colorSecondaryText, width: 1))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppStrings.account_appInfo_appName_title,
                                style: Style.descTextStyle()),
                            Text(state.appName,
                                style: Style.descTextBoldStyle())
                          ],
                        ),
                      ),Container(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.colorSecondaryText, width: 1))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Text(AppStrings.account_appInfo_version_title,
                                  style: Style.descTextStyle()),
                            ),
                            Text(state.appBuildVersion,
                                style: Style.descTextBoldStyle())
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.colorSecondaryText, width: 1))
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppStrings.account_appInfo_buildNumber_title,
                                style: Style.descTextStyle()),
                            Text(state.appBuildNumber,
                                style: Style.descTextBoldStyle())
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}
