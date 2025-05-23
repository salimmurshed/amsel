part of 'subscription_bloc.dart';

@freezed
class SubscriptionWithInitialState with _$SubscriptionWithInitialState {
  const factory SubscriptionWithInitialState({
    required List<ProductDetails>? products,
    required List<ProductDetails>? updatedProducts,
    required bool isLoading,
    required bool isPurchaseLoading,
    required String errorMessage,
    required String message,
    required SubscriptionData? subscriptionRequest,
    required List<GooglePlayPurchaseDetails>? pastPurchases,
    required bool userHasSubscription,
    SubscriptionData? subscriptionData,
    required List<LatestReceiptInfo> iosPastPurchases,
    required List<PurchaseDetails> purchaseList,
    required Map<String, PurchaseDetails>? purchases,
    required String originalTransactionId,
    required bool canUpdate,
    required String upgradeDegradeReason,
  }) = _SubscriptionWithInitialState;

  factory SubscriptionWithInitialState.initial() =>
      const SubscriptionWithInitialState(
          products: [],
          updatedProducts: [],
          isLoading: true,
          isPurchaseLoading: false,
          errorMessage: "",
          message: "",
          subscriptionRequest: null,
        pastPurchases: [],
        userHasSubscription: false,
        subscriptionData: null,
        iosPastPurchases: [],
        purchaseList: [],
        purchases: null,
        originalTransactionId: "",
        canUpdate: false,
        upgradeDegradeReason: ""
      );
}
