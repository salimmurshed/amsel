part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
  @override
  List<Object?> get props => [];
}

class InitializeInAppPurchase extends SubscriptionEvent {}

class TriggerFetchCurrentSubscription extends SubscriptionEvent{
  final bool isInitial;
  const TriggerFetchCurrentSubscription({this.isInitial = false
  });
}

class TriggerRestorePurchase extends SubscriptionEvent{
  final bool isFromSettingPage;
  final bool flag;
  const TriggerRestorePurchase({this.isFromSettingPage = false, this.flag = false});
}

class TriggerFetchProducts extends SubscriptionEvent{
  final bool isInitial;
  const TriggerFetchProducts({this.isInitial = false
  });
}

class TriggerIAPurchase extends SubscriptionEvent{
  final ProductDetails productDetails;
  final bool? isUpgrade;
  const TriggerIAPurchase({required this.productDetails, this.isUpgrade});
}

class TriggerSavePurchase extends SubscriptionEvent{
  final SubscriptionData transactionRequest;
  const TriggerSavePurchase({required this.transactionRequest});
}

class TriggerProductListenUpdate extends SubscriptionEvent{
  final List<PurchaseDetails> purchasedList;
  const TriggerProductListenUpdate({required  this.purchasedList});
}

class TriggerUpgradeDowngradePossibleEvent extends SubscriptionEvent{}

class TriggerRefreshEvent extends SubscriptionEvent{}

