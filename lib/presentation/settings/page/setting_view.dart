import 'dart:io';
import 'package:amsel_flutter/common/functions/iap_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../subscription/bloc/subscription_bloc.dart';
import '../widget/build_menu.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SubscriptionBloc subscriptionBloc = instance<SubscriptionBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isLeading: false,
        title: AppLocalizations.of(context)!.btnNavigation_Setting_title,
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionWithInitialState>(
          bloc: subscriptionBloc..add(TriggerRefreshEvent()),
          builder: (context, state) {
            return Stack(
              children: [
                Container(),
                const Positioned(
                    bottom: -50,
                    right: 0,
                    child: ImageView(
                      imagePath: Assets.icBottomBG,
                    )),
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: screenVPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.isLoading
                          ? const Center(child: CircularIndicator())
                          : Column(
                              children: [
                                state.userHasSubscription
                                    ? GestureDetector(
                                        onTap: () async {
                                          await Navigator.pushNamed(
                                              context,
                                              RouteName.routeSubscription);
                                            subscriptionBloc.add(TriggerRefreshEvent());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenHPadding),
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    cardHorizontalPadding,
                                                vertical: cardVerticalPadding),
                                            decoration:
                                                Style.containerShadowDecoration(
                                                    radius: containerRadius),
                                            child: Column(
                                              children: [
                                                Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .setting_subscription_title,
                                                    style: Style
                                                        .descTextBoldStyle()),
                                                SizedBox(height: 1.h),
                                                Text(
                                                    getActiveSubscription(
                                                        product: state
                                                                    .subscriptionData !=
                                                                null
                                                            ? state
                                                                .subscriptionData!
                                                                .productId
                                                            : "",
                                                        context: context),
                                                    style: Style.headerStyle(
                                                        color: AppColor
                                                            .colorPrimary)),
                                                SizedBox(height: 1.h),
                                                Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .setting_subscription_noOfTraining,
                                                    style:
                                                        Style.infoTextStyle()),
                                                SizedBox(
                                                    height:
                                                        menuCardVerticalPadding),
                                                Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .setting_subscription_manageSubscription,
                                                    style: Style.infoTextBoldStyle(
                                                        color: AppColor
                                                            .colorTextLightBG,
                                                        textDecoration:
                                                            TextDecoration
                                                                .underline)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                  padding: EdgeInsets.only(left: screenHPadding),
                                  decoration: Style.containerShadowDecoration(),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var flag = await Navigator.pushNamed(
                                              context, RouteName.routeSubscription);
                                          if (flag == true) {
                                            subscriptionBloc
                                                .add(TriggerRefreshEvent());
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: ScreenUtil().setWidth(200),
                                              padding: EdgeInsets.only(right: 18.w),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 6.h),
                                                    child: Text(
                                                        AppLocalizations.of(context)!
                                                            .setting_menu_appStoreBtn,
                                                        style: Style.subHeaderStyle()),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(8.w, 2.h, 44.w, 2.h),
                                                    child: const CustomDivider(),
                                                  ),
                                                  Text(
                                                      AppLocalizations.of(context)!
                                                          .setting_menu_appStoreInfo,
                                                      style: Style.infoTextStyle()),
                                                  SizedBox(height: 10.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(containerRadius),
                                              bottomLeft: Radius.circular(containerRadius),
                                            ),
                                            child: ImageView(
                                              width: ScreenUtil().setWidth(150),
                                              imagePath: Assets.icBGONE,
                                              // fit: BoxFit.fill
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            screenHPadding, screenVPadding, screenHPadding, 0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .setting_menu_amsel_app,
                            style: Style.infoTextBoldStyle()),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              buildMenu(
                                argument: true,
                                routeName: RouteName.routeOnboarding,
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_introBtn,
                                iconUrl: Assets.icBook,
                                context: context,
                              ),
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_tipsBtn,
                                link: AppStrings.myAccount_menu_tips_link,
                                isBrowser: true,
                                iconUrl: Assets.icBulb,
                                context: context,
                              ),
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_teamBtn,
                                link: AppStrings.myAccount_menu_team_link,
                                isBrowser: true,
                                iconUrl: Assets.icPeople,
                                context: context,
                              ),
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_rateUsBtn,
                                link: Platform.isIOS
                                    ? AppStrings.myAccount_menu_rateUs_Ioslink
                                    : AppStrings
                                        .myAccount_menu_rateUs_Androidlink,
                                isBrowser: true,
                                iconUrl: Assets.icStarSetting,
                                context: context,
                              ),
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_teachersBtn,
                                link: AppStrings.myAccount_menu_teachers_link,
                                isBrowser: true,
                                iconUrl: Assets.icCap,
                                context: context,
                              ),
                              buildMenu(
                                routeName: RouteName.routeContactUs,
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_contactBtn,
                                iconUrl: Assets.icMail,
                                context: context,
                              ),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            screenHPadding, screenVPadding, screenHPadding, 0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .setting_menu_app_setting,
                            style: Style.infoTextBoldStyle()),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              buildMenu(
                                routeName: RouteName.routePushNotification,
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_notification_part_two,
                                iconUrl: Assets.icNotification,
                                context: context,
                              ),
                              buildMenu(
                                routeName: RouteName.routeAppInformation,
                                menuTitle:
                                    '${AppLocalizations.of(context)!.setting_menu_appInfo_partOne}${AppLocalizations.of(context)!.setting_menu_appInfo_partTwo}',
                                iconUrl: Assets.icAppInfo,
                                context: context,
                              ),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            screenHPadding, screenVPadding, screenHPadding, 0),
                        child: Text(
                            AppLocalizations.of(context)!.setting_menu_legal,
                            style: Style.infoTextBoldStyle()),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_privacyBtn,
                                link: AppStrings.myAccount_menu_privacy_link,
                                isBrowser: true,
                                iconUrl: Assets.icDataPrivacy,
                                context: context,
                              ),
                              buildMenu(
                                menuTitle: AppLocalizations.of(context)!
                                    .setting_menu_EULABtn,
                                link: AppStrings.myAccount_menu_eula_link,
                                isBrowser: true,
                                iconUrl: Assets.icEula,
                                context: context,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
