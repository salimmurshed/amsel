import 'package:amsel_flutter/common/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

getCTAForUpgradeDowngrade({required String productId, required BuildContext context, String? currentSubscriptionProductId = ""}) {
  if (currentSubscriptionProductId == AppStrings().yearlyPlan) {
    return AppLocalizations.of(context)!.subscription_downgrade;
  }
  if (currentSubscriptionProductId == AppStrings().monthlyPlan) {
    return AppLocalizations.of(context)!.subscription_upgrade;
  }
  if (currentSubscriptionProductId == AppStrings().threeMonthPlan) {
    if (productId == AppStrings().monthlyPlan) {
      return AppLocalizations.of(context)!.subscription_downgrade;
    } else {
      return AppLocalizations.of(context)!.subscription_upgrade;
    }
  } else {
    return AppLocalizations.of(context)!
        .setting_menu_buyBtn;
  }
}

getProductTitle({required String product, required BuildContext context}) {
  if(product == AppStrings().monthlyPlan){
    return AppLocalizations.of(context)!.subscription_monthly_title;
  } else if(product == AppStrings().threeMonthPlan){
    return AppLocalizations.of(context)!.subscription_three_monthly_title;
  } else if(product == AppStrings().yearlyPlan){
    return AppLocalizations.of(context)!.subscription_yearly_title;
  } else {
    return "";
  }
}

getActiveSubscription({required String product, required BuildContext context}) {
  if(product == AppStrings().monthlyPlan){
    return AppLocalizations.of(context)!.subscription_active_monthly;
  } else if(product == AppStrings().threeMonthPlan){
    return AppLocalizations.of(context)!.subscription_active_three_monthly;
  } else if(product == AppStrings().yearlyPlan){
    return AppLocalizations.of(context)!.subscription_active_yearly;
  } else {
    return "";
  }
}

getProductBilling({required String product, required BuildContext context}) {
  if(product == AppStrings().monthlyPlan){
    return AppLocalizations.of(context)!.subscription_monthly_billing;
  } else if(product == AppStrings().threeMonthPlan){
    return AppLocalizations.of(context)!.subscription_three_monthly_billing;
  } else {
    return AppLocalizations.of(context)!.subscription_yearly_billing;
  }
}

getExtension({required BuildContext context, required String productId}) {
  if(productId == AppStrings().threeMonthPlan){
    return AppLocalizations.of(context)!.subscription_three_monthly;
  } else if(productId == AppStrings().yearlyPlan){
    return AppLocalizations.of(context)!.subscription_yearly;
  } else {
    return AppLocalizations.of(context)!.subscription_monthly;
  }
}