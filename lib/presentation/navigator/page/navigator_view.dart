import 'dart:io';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:amsel_flutter/presentation/dashboard/page/dashboard_view.dart';
import 'package:amsel_flutter/presentation/settings/page/setting_view.dart';
import 'package:amsel_flutter/presentation/statistics/bloc/statistic_bloc.dart';
import 'package:amsel_flutter/presentation/statistics/page/statistics_view.dart';
import 'package:amsel_flutter/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../data/repository/repository_dependencies.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../bloc/navigators_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/bottom_bar_item.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  final NavigatorsBloc navigatorBloc = instance<NavigatorsBloc>();

  @override
  void initState() {
    // TODO: implement initState
    RepositoryDependencies.streamSubscription = RepositoryDependencies.inAppPurchase.purchaseStream.listen(
          (List<PurchaseDetails> purchaseDetailsList) {
        debugPrint("purchase details list is ${purchaseDetailsList.length}");
        BlocProvider.of<SubscriptionBloc>(context).add(TriggerProductListenUpdate(purchasedList: purchaseDetailsList));
      },
      onError: (Object error) {
        debugPrint("get Data error is $error");
      },
      onDone: () {
        RepositoryDependencies.streamSubscription.cancel();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      RepositoryDependencies.inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigatorsBloc>(
      create: (context) => navigatorBloc,
      child: BlocListener<NavigatorsBloc, NavigatorStateWithInitialState>(
        listener: (context, state) {
          if (state.currentIndex == 1) {
            BlocProvider.of<StatisticBloc>(context)
                .add(TriggerResetGoalEvent());
          }
        },
        child: BlocBuilder<NavigatorsBloc, NavigatorStateWithInitialState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.colorWhite,
              body: Stack(
                children: [
                  Container(),
                  const Positioned(
                      bottom: -50,
                      right: 0,
                      child: ImageView(
                        imagePath: Assets.icBottomBG,
                      )),
                  state.currentIndex == 0
                      ? const DashBoardView()
                      : state.currentIndex == 1
                          ? const StatisticsView()
                          : const SettingView(),
                ],
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: Platform.isIOS ? 16.h : 10.h),
                    decoration: BoxDecoration(
                        color: AppColor.colorVeryLightGrey,
                        border: Border(
                            top: BorderSide(
                          color: AppColor.colorLightGrey,
                        ))),
                    child: Row(
                      children: [
                        Expanded(
                          child: bottomBarItem(

                              isSelected:
                                  state.currentIndex == 0 ? true : false,
                              text: AppLocalizations.of(context)!
                                  .btnNavigation_training_title,
                              svgPath: Assets.icNavMic,
                              onTap: () {
                                navigatorBloc.add(const TriggerNavigatorsButton(
                                    currentIndex: 0));
                              }),
                        ),
                        Expanded(
                          child: bottomBarItem(
                              isSelected:
                                  state.currentIndex == 1 ? true : false,
                              text: AppLocalizations.of(context)!
                                  .btnNavigation_statistic_title,
                              svgPath: Assets.icNavStatistic,
                              onTap: () {
                                navigatorBloc.add(const TriggerNavigatorsButton(
                                    currentIndex: 1));
                              }),
                        ),
                        Expanded(
                          child: bottomBarItem(
                              isSelected:
                                  state.currentIndex == 2 ? true : false,
                              text: AppLocalizations.of(context)!
                                  .btnNavigation_Setting_title,
                              svgPath: Assets.icNavSetting,
                              onTap: () {
                                navigatorBloc.add(const TriggerNavigatorsButton(
                                    currentIndex: 2));
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
