import 'dart:io';
import 'package:amsel_flutter/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/functions/iap_functions.dart';
import '../../../imports/common.dart';
import '../widget/bullet_point_widget.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionWithInitialState>(
        bloc: BlocProvider.of<SubscriptionBloc>(context)..add(const TriggerFetchProducts(isInitial: true)),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.subscription_appBar_title,
              onTap: () {
                Navigator.pop(context, true);
              },
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: screenHPadding),
                  child: CustomButton(
                    buttonSize: ButtonSize.small,
                    variant: ButtonVariant.btnPrimary,
                    text: AppLocalizations.of(context)!
                        .subscription_restore_subscriptionBtn,
                    onTap: () {
                      BlocProvider.of<SubscriptionBloc>(context).add(const TriggerRestorePurchase());
                    },
                  ),
                )
              ],
            ),
            body: Stack(children: [
              Container(),
              const Positioned(
                  bottom: -50,
                  right: 0,
                  child: ImageView(
                    imagePath: Assets.icBottomBG,
                  )),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        state.userHasSubscription
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenHPadding, vertical: screenVPadding),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: cardHorizontalPadding,
                                      vertical: cardVerticalPadding),
                                  decoration: Style.containerShadowDecoration(
                                      radius: containerRadius),
                                  child: Column(
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .setting_subscription_title,
                                          style: Style.descTextBoldStyle()),
                                      SizedBox(height: 1.h),
                                      Text(
                                          getActiveSubscription(
                                              product:
                                                  state.subscriptionData != null
                                                      ? state.subscriptionData!
                                                          .productId
                                                      : "",
                                              context: context),
                                          style: Style.headerStyle(
                                              color: AppColor.colorPrimary)),
                                      SizedBox(height: 1.h),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .setting_subscription_noOfTraining,
                                          style: Style.infoTextStyle()),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenHPadding,
                                    vertical: screenVPadding),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: cardHorizontalPadding,
                                      vertical: cardVerticalPadding),
                                  decoration: Style.containerShadowDecoration(
                                      radius: containerRadius),
                                  child: Column(
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .setting_subscription_title,
                                          style: Style.descTextBoldStyle()),
                                      SizedBox(height: 1.h),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .subscription_free_access,
                                          style: Style.headerStyle(
                                              color: AppColor.colorPrimary)),
                                      SizedBox(height: 1.h),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .subscription_info,
                                          textAlign: TextAlign.center,
                                          style: Style.infoTextStyle()),
                                    ],
                                  ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(bottom: widgetBottomPadding),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .subscription_offers_partOne,
                                    style: Style.subHeaderStyle()),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .subscription_offers_partTwo,
                                  style: Style.subHeaderStyle(
                                      colorBG: AppColor.colorPrimaryBG),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenHPadding),
                            child: Column(
                              children: [
                                state.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : state.isPurchaseLoading
                                        ? CustomLoader(
                                            height: 150.h,
                                            child: buildListView(
                                                state: state,
                                                bloc: BlocProvider.of<SubscriptionBloc>(context)))
                                        : buildListView(
                                            state: state,
                                            bloc: BlocProvider.of<SubscriptionBloc>(context)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: screenVPadding,
                                      bottom: widgetBottomPadding),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .subscription_further_info_title_partOne,
                                            style: Style.subHeaderStyle()),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .subscription_further_info_title_partTwo,
                                          style: Style.subHeaderStyle(
                                              colorBG: AppColor.colorPrimaryBG),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                    AppLocalizations.of(context)!
                                        .subscription_further_info_desc,
                                    style: Style.descTextStyle()),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.w, top: menuCardVerticalPadding),
                                  child: bulletPointText(
                                      text: AppLocalizations.of(context)!
                                          .subscription_further_info_pointOne),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: bulletPointText(
                                      text: AppLocalizations.of(context)!
                                          .subscription_further_info_pointTwo),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: bulletPointText(
                                      text: Platform.isIOS ? AppLocalizations.of(context)!
                                          .subscription_further_info_pointThree_ios : AppLocalizations.of(context)!
                                          .subscription_further_info_pointThree_android),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenVPadding),
                                  child: CustomButton(
                                    variant: ButtonVariant.btnPrimary,
                                    buttonSize: ButtonSize.large,
                                    text: AppLocalizations.of(context)!
                                        .setting_subscription_manageSubscription,
                                    onTap: () async {
                                      if (Platform.isIOS) {
                                        await openBrowserFromUrl(
                                            url:
                                                // "https://support.apple.com/en-us/HT202039"

                                                "https://apps.apple.com/account/subscriptions");
                                      } else {
                                        // ProductDetails projectDetail =
                                        //     state.products![state.products!
                                        //         .indexWhere((element) =>
                                        //             element.id ==
                                        //             state.subscriptionData!
                                        //                 .productId)];
                                        // subscriptionBloc.add(TriggerIAPurchase(
                                        //     productDetails: projectDetail));
                                        await openBrowserFromUrl(
                                            url:
                                                "https://play.google.com/store/account/subscriptions");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ]),
          );
        });
  }
}

buildListView(
    {required SubscriptionWithInitialState state,
    required SubscriptionBloc bloc}) {
  return ListView.separated(
    itemCount: state.updatedProducts!.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      var data = state.updatedProducts![index];
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: containerHorizontalPadding,
            vertical: containerVerticalPadding),
        decoration: Style.containerShadowDecoration(radius: containerRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getProductTitle(product: data.id, context: context),
                style: Style.descTextBoldStyle()),
            SizedBox(height: containerVerticalPadding),
            bulletPointText(
                text: AppLocalizations.of(context)!
                    .setting_subscription_noOfTraining),
            bulletPointText(
                text: getProductBilling(product: data.id, context: context)),
            bulletPointText(
                text: AppLocalizations.of(context)!.subscription_cancel_info),
            bulletPointText(
                text:
                    AppLocalizations.of(context)!.subscription_automation_info),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                      "${data.price} / ${getExtension(context: context, productId: data.id)}",
                      textAlign: TextAlign.end,
                      style: Style.descTextBoldStyle()),
                ),
                SizedBox(width: 8.w),
                CustomButton(
                  buttonSize: ButtonSize.small,
                  // width: state.subscriptionData != null ? MediaQuery.of(context).size.width/3 : 70.w,
                  variant: ButtonVariant.btnPrimary,
                  text: getCTAForUpgradeDowngrade(
                      productId: data.id,
                      context: context,
                      currentSubscriptionProductId:
                          state.subscriptionData != null
                              ? state.subscriptionData!.productId
                              : ""),
                  onTap: () async {
                    if (state.subscriptionData != null) {
                      bool isUpgrade = getCTAForUpgradeDowngrade(
                          context: context,
                          productId: data.id,
                          currentSubscriptionProductId:
                          state.subscriptionData != null
                              ? state
                              .subscriptionData!.productId
                              : "") ==
                          "Upgrade"
                          ? true
                          : false;
                      if(state.subscriptionData!.nextProductId == data.id){
                        String message = isUpgrade
                            ? AppLocalizations.of(context)!
                            .subscription_upgrade_toast
                            : AppLocalizations.of(context)!
                            .subscription_downgrade_toast;
                        Toast.nullableIconToast(message: message, isErrorBooleanOrNull: null);
                      } else {
                        bloc.add(TriggerIAPurchase(
                            isUpgrade: isUpgrade,
                            productDetails: data));
                      }
                    } else {
                      bloc.add(TriggerIAPurchase(productDetails: data));
                    }
                  },
                )
              ],
            )
          ],
        ),
      );
    },
    separatorBuilder: (context, state) {
      return SizedBox(height: widgetBottomPadding);
    },
  );
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}