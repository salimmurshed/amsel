import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amsel_flutter/main.dart';
import 'package:amsel_flutter/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/api_request_models/subscription_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../data/model/api_response_models/ios_recipt_response.dart';
import '../../../data/repository/repository_dependencies.dart';
import '../../../imports/common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../page/subscription_view.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

part 'subscription_bloc.freezed.dart';

class SubscriptionBloc
    extends Bloc<SubscriptionEvent, SubscriptionWithInitialState> {
  // late StreamSubscription<List<PurchaseDetails>> streamSubscription;
  PurchaseStatus status = PurchaseStatus.pending;
  bool isRestore = false;

  SubscriptionBloc() : super(SubscriptionWithInitialState.initial()) {
    // getData(isRestore: false);
    // listenToPurchaseUpdates();
    // on<InitializeInAppPurchase>(_onInitialize);
    on<TriggerFetchCurrentSubscription>(_onTriggerFetchCurrentSubscription);
    on<TriggerFetchProducts>(_onTriggerFetchProducts);
    on<TriggerIAPurchase>(_onTriggerIAPurchase);
    on<TriggerProductListenUpdate>(_onTriggerProductListenUpdate);
    on<TriggerSavePurchase>(_onTriggerSavePurchase);
    on<TriggerRestorePurchase>(_onTriggerRestorePurchase);
    on<TriggerRefreshEvent>(_onTriggerRefreshEvent);
    on<TriggerUpgradeDowngradePossibleEvent>(
        _onTriggerUpgradeDowngradePossibleEvent);
  }

  // void _onInitialize(
  //     InitializeInAppPurchase event, Emitter<SubscriptionWithInitialState> emit) {
  //   debugPrint("initialize in app purchase");
  //   streamSubscription = RepositoryDependencies.inAppPurchase.purchaseStream.listen(
  //         (List<PurchaseDetails> purchaseDetailsList) {
  //           debugPrint("purchase details list is ${purchaseDetailsList.length}");
  //           add(TriggerProductListenUpdate(purchasedList: purchaseDetailsList));
  //     },
  //     onError: (Object error) {
  //       debugPrint("get Data error is $error");
  //     },
  //     onDone: () {
  //       streamSubscription.cancel();
  //     },
  //   );
  // }

  @override
  Future<void> close() {
    // streamSubscription.cancel();
    return super.close();
  }
  // getData() async {
  //   final Stream<List<PurchaseDetails>> purchaseUpdated =
  //       RepositoryDependencies.inAppPurchase.purchaseStream;
  //   streamSubscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
  //     debugPrint("purchase details list is ${purchaseDetailsList.length}");
  //     add(TriggerProductListenUpdate(purchasedList: purchaseDetailsList));
  //   }, onDone: () {
  //     debugPrint("on done section call ===============");
  //     streamSubscription.cancel();
  //   }, onError: (Object error) {
  //     debugPrint("get Data error is $error");
  //   });
  // }

  FutureOr<void> _onTriggerFetchProducts(TriggerFetchProducts event, Emitter<SubscriptionWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    bool isAvailable = await RepositoryDependencies.inAppPurchase.isAvailable();
    // debugPrint("In-app purchase is available ?? $isAvailable");
    if (isAvailable) {
      final ProductDetailsResponse response = await RepositoryDependencies
          .inAppPurchase
          .queryProductDetails(subscriptionIds.toSet());
      // debugPrint("Product details response: ${response.productDetails}");
      List<ProductDetails> products = <ProductDetails>[];
      List<ProductDetails> updateSubscription = <ProductDetails>[];
      products = response.productDetails;
      products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      List<PurchaseDetails> pastPurchases = [];
      List<GooglePlayPurchaseDetails> pastPurchase = [];
      Map<String, PurchaseDetails> purchases = {};
      if (Platform.isAndroid) {
        pastPurchases = await getPastPurchases();
        pastPurchase = pastPurchases as List<GooglePlayPurchaseDetails>;
        purchases = Map<String, PurchaseDetails>.fromEntries(
            pastPurchases.map((PurchaseDetails purchase) {
              if (purchase.pendingCompletePurchase) {
                completeTransaction(purchase);
              }
              return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
            })
        );
      }
      else {
          final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          RepositoryDependencies.inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
          await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
          await finishIosTransaction();
      }
      updateSubscription.addAll(products);
      emit(state.copyWith(
        products: updateSubscription,
        updatedProducts: updateSubscription,
        purchases: purchases,
        pastPurchases: pastPurchase,
      ));
      add(const TriggerFetchCurrentSubscription(isInitial: true));
    }
    else {
      emit(state.copyWith(
          isLoading: false,
          isPurchaseLoading: false,
          message: "In-app purchase is not available"));
    }
  }

  FutureOr<void> _onTriggerIAPurchase(TriggerIAPurchase event, Emitter<SubscriptionWithInitialState> emit) async {
    emit(state.copyWith(isPurchaseLoading: true));
    PurchaseParam purchaseParam;
    if (Platform.isAndroid) {

      // debugPrint("purchases is ${purchases.entries.toSet()}");
      // debugPrint("purchase detail is ${state.pastPurchases}");

      // debugPrint("here ${event.productDetails.id} upgrade ${event.isUpgrade} and ${purchases.entries}");
      GooglePlayPurchaseDetails? oldSubscription = await getOldSubscription(
          event.isUpgrade, event.productDetails, state.purchases);
      // debugPrint("old sub is $oldSubscription");
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: event.productDetails,
        changeSubscriptionParam: (oldSubscription != null)
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                prorationMode: ProrationMode.immediateWithTimeProration,
              )
            : null,
      );
    }
    else {
      await finishIosTransaction();
      purchaseParam = PurchaseParam(
        productDetails: event.productDetails,
      );
    }
    try {
      await RepositoryDependencies.inAppPurchase
          .buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint("purchase error is $e");
      emit(state.copyWith(isPurchaseLoading: false, message: e.toString()));
    }
    // debugPrint("purchase Details is $purchaseDetails");
  }

  Future<GooglePlayPurchaseDetails?> getOldSubscription(
      bool? isUpgrade,
      ProductDetails productDetails,
      Map<String, PurchaseDetails>? purchases) async {
    // debugPrint("here old sub ${productDetails.id} $isUpgrade and ${purchases!.entries.toList()}");
    if (isUpgrade != null) {
      // debugPrint("is upgrade value $isUpgrade");
      GooglePlayPurchaseDetails? oldSubscription;
      // Check if the current product is a monthly plan and if there's an existing three-month or yearly plan
      if (productDetails.id == AppStrings().monthlyPlan) {
        if (purchases![AppStrings().threeMonthPlan] != null) {
          oldSubscription = purchases[AppStrings().threeMonthPlan]!
              as GooglePlayPurchaseDetails;
        } else if (purchases[AppStrings().yearlyPlan] != null) {
          oldSubscription =
              purchases[AppStrings().yearlyPlan]! as GooglePlayPurchaseDetails;
        }
      }

      // Check if the current product is a three-month plan and if there's an existing monthly or yearly plan
      else if (productDetails.id == AppStrings().threeMonthPlan) {
        if (purchases![AppStrings().monthlyPlan] != null) {
          oldSubscription =
              purchases[AppStrings().monthlyPlan]! as GooglePlayPurchaseDetails;
        } else if (purchases[AppStrings().yearlyPlan] != null) {
          oldSubscription =
              purchases[AppStrings().yearlyPlan]! as GooglePlayPurchaseDetails;
        }
      }

      // Check if the current product is a yearly plan and if there's an existing monthly or three-month plan
      else if (productDetails.id == AppStrings().yearlyPlan) {
        if (purchases![AppStrings().monthlyPlan] != null) {
          oldSubscription =
              purchases[AppStrings().monthlyPlan]! as GooglePlayPurchaseDetails;
        } else if (purchases[AppStrings().threeMonthPlan] != null) {
          oldSubscription = purchases[AppStrings().threeMonthPlan]!
              as GooglePlayPurchaseDetails;
        }
      }
      return oldSubscription;
    } else {
      return null;
    }
  }

  FutureOr<void> _onTriggerFetchCurrentSubscription(TriggerFetchCurrentSubscription event, Emitter<SubscriptionWithInitialState> emit) async {
    SubscriptionData? currentSubscription;
    List<ProductDetails> unmodifiedProductList = state.products!;
    List<ProductDetails> productList = List.from(unmodifiedProductList);
    bool userHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    try {
    emit(state.copyWith(userHasSubscription: userHasSubscription));
    String? jsonString = await RepositoryDependencies.appSettingsData.getUserSubscription();
    debugPrint("userHasSubscription is $userHasSubscription, Subscription is $jsonString");
    if (userHasSubscription && jsonString != null && jsonString.isNotEmpty) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      currentSubscription = SubscriptionData.fromJson(jsonMap);
      debugPrint("Current subscription is $jsonMap");
      debugPrint("current date is ${currentSubscription.expiryDate!.isBefore(DateTime.now().toUtc())}");
      debugPrint("current date is ${DateTime.now().toUtc()}");

      if(Platform.isAndroid){
        emit(state.copyWith(isPurchaseLoading: true));
        int index = -1;
        index = productList
            .indexWhere((element) =>
        element.id == currentSubscription!.productId);
        BlocProvider.of<DashboardBloc>(navigatorKey.currentContext!).add(
            TriggerRefresh());
        if (index != -1) {
          productList.removeAt(index);
          emit(state.copyWith(
            isLoading: false,
            isPurchaseLoading: false,
            updatedProducts: productList,
            userHasSubscription: true,
            subscriptionData: currentSubscription,
          ));
          add(TriggerUpgradeDowngradePossibleEvent());
          return;
        }
        else {
          await RepositoryDependencies.appSettingsData
              .setUserSubscription(jsonEncodedValue: '');
          await RepositoryDependencies.appSettingsData
              .setSubscriptionHasSubscription(value: false);
          emit(state.copyWith(
            isLoading: false,
            isPurchaseLoading: false,
            updatedProducts: productList,
            subscriptionData: currentSubscription,
          ));
          return;
        }
      } else {
        if (currentSubscription.expiryDate!.isBefore(DateTime.now().toUtc())) {
          await RepositoryDependencies.appSettingsData
              .setUserSubscription(jsonEncodedValue: '');
          await RepositoryDependencies.appSettingsData
              .setSubscriptionHasSubscription(value: false);
          emit(state.copyWith(
            isLoading: false,
            isPurchaseLoading: false,
            userHasSubscription: false,
            subscriptionData: null,
          ));
          return;
        }
        else {
          emit(state.copyWith(isPurchaseLoading: true));
          int index = -1;
          index = productList
              .indexWhere((element) =>
          element.id == currentSubscription!.productId);
          BlocProvider.of<DashboardBloc>(navigatorKey.currentContext!).add(
              TriggerRefresh());
          if (index != -1) {
            productList.removeAt(index);
            emit(state.copyWith(
              isLoading: false,
              isPurchaseLoading: false,
              updatedProducts: productList,
              userHasSubscription: true,
              subscriptionData: currentSubscription,
            ));
            add(TriggerUpgradeDowngradePossibleEvent());
            return;
          }
          else {
            await RepositoryDependencies.appSettingsData
                .setUserSubscription(jsonEncodedValue: '');
            await RepositoryDependencies.appSettingsData
                .setSubscriptionHasSubscription(value: false);
            emit(state.copyWith(
              isLoading: false,
              isPurchaseLoading: false,
              updatedProducts: productList,
              subscriptionData: currentSubscription,
            ));
            return;
          }
        }
      }
    }
    else {
      emit(state.copyWith(
          isLoading: false,
          isPurchaseLoading: false,
          userHasSubscription: userHasSubscription,
          subscriptionData: currentSubscription));
    }
    } catch (e) {
      emit(state.copyWith(isLoading: false, isPurchaseLoading: false));
    }
  }

  FutureOr<void> _onTriggerProductListenUpdate(TriggerProductListenUpdate event, Emitter<SubscriptionWithInitialState> emit) async {
    debugPrint("for loop started purchase length is ${event.purchasedList.length}");
    PurchaseDetails? lastPurchaseDetails;
    List<PurchaseDetails> purchaseList = [];
    int processedCount = 0;

    for (final PurchaseDetails purchaseDetails in event.purchasedList) {
      status = purchaseDetails.status;
      // debugPrint("purchase listen details is ${purchaseDetails.productID} and ${purchaseDetails.status.name}");

        if(Platform.isIOS)  {
        if (purchaseDetails.pendingCompletePurchase) {
          await completeTransaction(purchaseDetails);
        }
      }
      if (purchaseDetails.status == PurchaseStatus.pending) {
        emit(state.copyWith(isPurchaseLoading: true));
      } else if (purchaseDetails.status == PurchaseStatus.canceled || purchaseDetails.status == PurchaseStatus.error) {
        if (purchaseDetails.pendingCompletePurchase) {
          await completeTransaction(purchaseDetails);
        }
        emit(state.copyWith(isPurchaseLoading: false, isLoading: false, message: purchaseDetails.error!.message));
      } else {
        // if (purchaseDetails.status == PurchaseStatus.error) {
        //   debugPrint("Error: ${purchaseDetails.error}");
        //   emit(state.copyWith(
        //     isLoading: false,
        //     message: purchaseDetails.error!.message,
        //     isPurchaseLoading: false,
        //   ));
        // }
        if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // debugPrint("purchaseDetails: $purchaseDetails");
          lastPurchaseDetails = purchaseDetails;
          await completeTransaction(purchaseDetails);
          if(Platform.isAndroid) {
            emit(state.copyWith(isPurchaseLoading: false, originalTransactionId: purchaseDetails.verificationData.localVerificationData));
          }
        }
        debugPrint("purchaseDetails: ${purchaseDetails.pendingCompletePurchase}");
        if (purchaseDetails.pendingCompletePurchase) {
          await completeTransaction(purchaseDetails);
        }
      }
      processedCount++;
    }
    // processedCount++;
    debugPrint("processedCount: $processedCount and list length is ${event.purchasedList.length} ${event.purchasedList.isNotEmpty}");
    // Only proceed with verification after processing all items
    if (processedCount == event.purchasedList.length && event.purchasedList.isNotEmpty) {
      debugPrint("for loop completed");
      if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
        purchaseList = event.purchasedList.where((element) => (element.status == PurchaseStatus.purchased || element.status == PurchaseStatus.restored)).toList();
        debugPrint("purchase list is ${purchaseList.length}");
        emit(state.copyWith(isPurchaseLoading: true, purchaseList: purchaseList));
        debugPrint("before verify purchase");
          await verifyPurchase(
              lastPurchaseDetails: lastPurchaseDetails,
              purchaseList: purchaseList);
          debugPrint("receipt verified");
        bool userHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
          emit(state.copyWith(isPurchaseLoading: false, isLoading: false, userHasSubscription: userHasSubscription));
      }
    } else {
      if(isRestore){
        Toast.nullableIconToast(
            message: AppLocalizations.of(navigatorKey.currentContext!)!.subscription_restore_failure_toast_msg,
            isErrorBooleanOrNull: true);
        isRestore = false;
      }
      emit(state.copyWith(isPurchaseLoading: false, isLoading: false));
    }
  }

  Future<void> verifyPurchase({PurchaseDetails? lastPurchaseDetails, required List<PurchaseDetails> purchaseList}) async {
    if (Platform.isIOS) {
      Temperatures? decodedResponse =
          await verifyPurchaseWithServer(purchase: lastPurchaseDetails);
      debugPrint("receipt is ${decodedResponse!.receipt!}");
      debugPrint("past purchases is ${decodedResponse.receipt!.inApp!.length}");
      debugPrint("renew is ${decodedResponse.pendingRenewalInfo!.length}");
      debugPrint("decodedResponse for verify purchase is $decodedResponse");
      LatestReceiptInfo? latestReceiptInfo;
      List<LatestReceiptInfo>? iosPurchases = decodedResponse.receipt!.inApp!;
      PendingRenewalInfo? pendingRenewalInfo =
          decodedResponse.pendingRenewalInfo![0];
      if (iosPurchases.isNotEmpty) {
        iosPurchases.sort((b, a) => a.expiresDate!.compareTo(b.expiresDate!));
        latestReceiptInfo = iosPurchases[0];
        debugPrint("latestReceiptInfo: ${jsonEncode(latestReceiptInfo)}");
        debugPrint("latestReceiptInfo: ${latestReceiptInfo.productId} renew info: ${pendingRenewalInfo.autoRenewProductId}");

        for (var element in iosPurchases) {
          // debugPrint("Receipt id ${element.productId} TID: ${element.transactionId} OID: ${element.originalTransactionId}  ED: ${element.expiresDate}");
          if (purchaseList.isNotEmpty) {
            for (var ele in purchaseList) {
              if (element.transactionId == ele.purchaseID) {
                debugPrint("match id ${element.productId} TID: ${element.transactionId} OID: ${element.originalTransactionId}");
                var date = element.expiresDate!;
                debugPrint("element date is $date ${latestReceiptInfo.transactionId == ele.purchaseID}");
                if (latestReceiptInfo.transactionId == ele.purchaseID) {
                  debugPrint("final match id ${element.productId} TID: ${element.transactionId} OID: ${element.originalTransactionId}");
                  break;
                } else {
                  debugPrint("no matchhing latest receipt");
                }
              } else {
                // debugPrint("no match");
              }
            }
          }
        }
        debugPrint("for loop done");
        bool takeCall = await checkForBECall(purchasedExpiryDate: latestReceiptInfo.expiresDate!);
        debugPrint("take call $takeCall");
        await finishIosTransaction();
        if (takeCall) {
          DateTime purchaseExpiry = getUTCTime(expiryDate: latestReceiptInfo.expiresDate!);
          debugPrint("expiry date is $purchaseExpiry");
          if(isRestore) {
            Toast.nullableIconToast(message: AppLocalizations.of(navigatorKey.currentContext!)!.subscription_restore_success_toast_msg, isErrorBooleanOrNull: false);
            isRestore = false;
          }
          add(TriggerSavePurchase(
              transactionRequest: SubscriptionData(
                  productId: latestReceiptInfo.productId!,
                  transactionId: latestReceiptInfo.transactionId!,
                  nextProductId: pendingRenewalInfo.autoRenewProductId!,
                  expiryDate: purchaseExpiry,
                  purchaseToken: latestReceiptInfo.originalTransactionId)
          ));

        } else {
          debugPrint("no need to call BE");
          if(isRestore) {
            Toast.nullableIconToast(
                message: AppLocalizations.of(navigatorKey.currentContext!)!
                    .subscription_restore_failure_toast_msg,
                isErrorBooleanOrNull: true);
            isRestore = false;
          }
          add(const TriggerFetchCurrentSubscription());
        }
      }
      else {
        debugPrint("iosPurchases is empty");
        return;
      }
    }
    else {
      List<GooglePlayPurchaseDetails> pastPurchases = await getPastPurchases();
      // debugPrint("past purchases is ${pastPurchases.length}");
      // debugPrint("last purchase details is ${lastPurchaseDetails?.verificationData.localVerificationData}");
      if (pastPurchases.isNotEmpty) {
        // Get the last purchased product (the most recent one)
        final lastPurchase = pastPurchases.first;
        // Convert the transaction date to DateTime
        final purchaseDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(lastPurchase.transactionDate!),
        );
        if (lastPurchaseDetails != null &&
            (lastPurchase.verificationData.serverVerificationData ==
                lastPurchaseDetails.verificationData.serverVerificationData)) {
          // debugPrint("both server matched");
          if (lastPurchase.status == PurchaseStatus.purchased || lastPurchase.status == PurchaseStatus.restored) {
            // debugPrint("status is purchased");
            // debugPrint("state subscription ${state.subscriptionData}");
            // final accessToken = await getAccessToken();
            // // debugPrint('Access Token: $accessToken');

            // Convert the transaction date to DateTime
            final purchaseDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(lastPurchase.transactionDate!), isUtc: true,
            );

            // Determine the subscription duration based on the product ID

            // Calculate the expiry date
            final expiryDate = getEstimatedExpiryDate(lastPurchase.productID, purchaseDate);
            // purchaseDate.add(subscriptionDuration(productId: lastPurchase.productID));

            // Print or save the expiry date
            // print('Last Purchase: ${lastPurchase.productID}');
            // print('Purchase Date: $purchaseDate');
            debugPrint('Expiry Date: $expiryDate');

            var pID = state.subscriptionData == null
                ? lastPurchase.productID
                : state.subscriptionData!.productId;

            add(TriggerSavePurchase(
                transactionRequest: SubscriptionData(
                    productId:
                        Platform.isAndroid ? lastPurchase.productID : pID,
                    transactionId: lastPurchase.purchaseID!,
                    purchaseToken:
                        lastPurchase.verificationData.serverVerificationData,
                    nextProductId: lastPurchase.productID,
                    expiryDate: expiryDate)));
            debugPrint("data saved");

            return;
          } else {
            debugPrint("status is not purchased");

            return;
          }
        } else {
          debugPrint("server not matched");
          return;
        }
      }
    }
  }

  Future<bool> checkForBECall({required String purchasedExpiryDate}) async {
    // debugPrint("BE CALL");
    // // debugPrint("REnew INFO: ${jsonEncode(pendingRenewalInfo)}");
    DateTime purchaseExpiry = getUTCTime(expiryDate: purchasedExpiryDate);
    DateTime currentDate = DateTime.now().toUtc();
    debugPrint("Expiry Date: $purchaseExpiry");
    debugPrint("Current Date: $currentDate and ${purchaseExpiry.isAfter(currentDate)}");
    // if (state.subscriptionData == null) {
      if (purchaseExpiry.isAfter(currentDate)) {
        debugPrint("if");
        return true;
      } else {
        return false;
      }
    // } else if (currentDate.isAfter(state.subscriptionData!.expiryDate!)) {
    //   if (state.iosPastPurchases.isNotEmpty) {
    //     DateTime lastPurchaseExpiry = getUTCTime(expiryDate: state.iosPastPurchases[0].expiresDate!);
    //     if (lastPurchaseExpiry == state.subscriptionData!.expiryDate!.toUtc() &&
    //         lastPurchaseExpiry.isAfter(currentDate)) {
    //       return false;
    //     } else if (lastPurchaseExpiry.isAfter(state.subscriptionData!.expiryDate!.toUtc())) {
    //       return true;
    //     }
    //   }
    //   return false;
    // }
    return false;
  }

  FutureOr<void> _onTriggerSavePurchase(TriggerSavePurchase event, Emitter<SubscriptionWithInitialState> emit) async {
    var originalTransactionId = event.transactionRequest.purchaseToken;
    emit(state.copyWith(isPurchaseLoading: true));
    // debugPrint("transaction request is ${event.transactionRequest}");
    String encodedValue = jsonEncode(event.transactionRequest.toJson());
    // debugPrint("encoded value is $encodedValue");
    try {
      await RepositoryDependencies.appSettingsData
          .setUserSubscription(jsonEncodedValue: encodedValue);
      await RepositoryDependencies.appSettingsData
          .setSubscriptionHasSubscription(value: true);
      if (event.transactionRequest.purchaseToken != null ||
          event.transactionRequest.purchaseToken!.isNotEmpty) {
        emit(state.copyWith(isPurchaseLoading: false, isLoading: false, originalTransactionId: originalTransactionId!));

        add(const TriggerFetchCurrentSubscription());
      } else {
        emit(state.copyWith(isPurchaseLoading: false, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isPurchaseLoading: false, isLoading: false));
    }
  }

  FutureOr<void> _onTriggerRestorePurchase(TriggerRestorePurchase event,
      Emitter<SubscriptionWithInitialState> emit) async {
    emit(state.copyWith(isPurchaseLoading: true));
    isRestore = true;
    debugPrint("restore purchase $isRestore");
    await RepositoryDependencies.inAppPurchase.restorePurchases().then((value) {
      debugPrint("restore purchase value is");
    });
  }

  FutureOr<void> _onTriggerUpgradeDowngradePossibleEvent(TriggerUpgradeDowngradePossibleEvent event, Emitter<SubscriptionWithInitialState> emit) async {
    emit(state.copyWith(isPurchaseLoading: true, isLoading: false));
    String upgradeDegradeReason = "";
    bool canUpdate = false;
    if (Platform.isIOS) {
      if (state.originalTransactionId ==
          state.subscriptionData!.purchaseToken) {
        canUpdate = true;
        upgradeDegradeReason = "You can purchase membership with this apple id";
      } else {
        if (state.originalTransactionId.isNotEmpty &&
            state.originalTransactionId !=
                state.subscriptionData!.purchaseToken) {
          canUpdate = false;
          upgradeDegradeReason =
              "Your apple id is connected with other account please change your apple id";
        } else {
          canUpdate = false;
        }
      }
    }
    if (Platform.isAndroid) {
      if (state.subscriptionData != null) {
        if (state.subscriptionData!.purchaseToken! ==
            state.originalTransactionId) {
          canUpdate = true;
          upgradeDegradeReason =
              "You can purchase membership with this apple id";
        } else {
          canUpdate = false;
          upgradeDegradeReason =
              "Your google id is connected with other account please change your google id";
        }
      }
    }
    emit(state.copyWith(
      isPurchaseLoading: false,
      isLoading: false,
      canUpdate: canUpdate,
      upgradeDegradeReason: upgradeDegradeReason,
    ));
  }

  FutureOr<void> _onTriggerRefreshEvent(TriggerRefreshEvent event, Emitter<SubscriptionWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    bool userHasSubscription =
        await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    // debugPrint("userHasSubscription is $userHasSubscription");
    String? mapString =
        await RepositoryDependencies.appSettingsData.getUserSubscription();
    // debugPrint("mapString is $mapString");
    if (userHasSubscription && mapString != null && mapString.isNotEmpty) {
      Map<String, dynamic> jsonMap = jsonDecode(mapString);
      SubscriptionData currentSubscription = SubscriptionData.fromJson(jsonMap);
      emit(state.copyWith(
          isLoading: false,
          userHasSubscription: userHasSubscription,
          subscriptionData: currentSubscription));
      return;
    } else {
      emit(state.copyWith(
          isLoading: false, userHasSubscription: userHasSubscription));
    }
  }

}

Future<Temperatures?> verifyPurchaseWithServer({
  PurchaseDetails? purchase,
  bool useSandbox = false,
  String receipt = "",
}) async {
  Temperatures? decodedResponse;

  if (receipt.isEmpty) {
    final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
        RepositoryDependencies.inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    final value = await iosPlatformAddition.refreshPurchaseVerificationData();

    if (value != null) {
      receipt = value.serverVerificationData;
      // debugPrint("Receipt: $receipt");
    } else {
      // debugPrint("Failed to retrieve receipt.");
      return null; // Early return if receipt can't be retrieved
    }
  }

  if (receipt.isNotEmpty) {
    final Map<String, dynamic> requestData = {
      'receipt-data': receipt,
      'password': '7f3c065f7cf44a76bfb0483450bec980',
      'exclude-old-transactions': 'true',
    };
    String url = useSandbox
        ? 'https://sandbox.itunes.apple.com/verifyReceipt'
        : 'https://buy.itunes.apple.com/verifyReceipt';

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        // debugPrint("Response JSON: $responseJson");
        decodedResponse = Temperatures.fromJson(responseJson);
        // debugPrint("Decoded Response: $decodedResponse");
        if (decodedResponse.status == 0) {
          return decodedResponse;
        } else if (decodedResponse.status == 21007) {
          return await verifyPurchaseWithServer(
            useSandbox: true,
            purchase: purchase,
            receipt: receipt,
          );
        } else if (decodedResponse.status == 21008) {
          return await verifyPurchaseWithServer(
            useSandbox: false,
            purchase: purchase,
            receipt: receipt,
          );
        } else {
          return decodedResponse;
        }
      } else {
        // debugPrint('Failed response from server: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // debugPrint('Error verifying receipt: $e');
      return null;
    }
  }
  return decodedResponse;
}

Future<SubscriptionData?> findActiveSubscription(
    LatestReceiptInfo? decodedResponse, String? newPID) async {
  SubscriptionData? currentSubscription;
  if (decodedResponse != null) {
    String? expiryDate = decodedResponse.expiresDate;
    DateTime purchaseExpiry = getUTCTime(expiryDate: expiryDate!);
    DateTime currentDate = DateTime.now().toUtc();
    if (purchaseExpiry.isAfter(currentDate)) {
      return currentSubscription;
    } else {
      currentSubscription = SubscriptionData(
        productId: decodedResponse.productId!,
        transactionId: decodedResponse.transactionId!,
        purchaseToken: decodedResponse.originalTransactionId,
        expiryDate: purchaseExpiry,
        nextProductId: newPID ?? decodedResponse.productId!,
      );
      await RepositoryDependencies.appSettingsData.setUserSubscription(
          jsonEncodedValue: jsonEncode(currentSubscription));
      await RepositoryDependencies.appSettingsData
          .setSubscriptionHasSubscription(value: true);
      return currentSubscription;
    }
  }
  return currentSubscription;
}

Future<List<GooglePlayPurchaseDetails>> getPastPurchases() async {
  List<GooglePlayPurchaseDetails> pastPurchases = <GooglePlayPurchaseDetails>[];
  final addition = RepositoryDependencies.inAppPurchase
      .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
  await addition.queryPastPurchases().then((value) {
    pastPurchases = value.pastPurchases;
    debugPrint("past purchases is ${pastPurchases.length} and value is ${value.pastPurchases.length}");
  });
  pastPurchases.sort((a, b) {
    return int.parse(b.transactionDate!)
        .compareTo(int.parse(a.transactionDate!));
  });
  for (var e in pastPurchases) {
    debugPrint("purchase Date is ${e.transactionDate}");
    DateTime purchaseDate = DateTime.fromMillisecondsSinceEpoch(int.parse(e.transactionDate!), isUtc: true);
    debugPrint("purchase date: $purchaseDate, Expiry Date is ${getEstimatedExpiryDate(e.productID, purchaseDate)} current date: ${DateTime.now().toUtc()}");
  }

  return pastPurchases;
}

getEncodedData() async {
  String? jsonString =
      await RepositoryDependencies.appSettingsData.getUserSubscription();
  if (jsonString == null || jsonString.isEmpty) {
    return null;
  } else {
    SubscriptionData subscriptionData =
        SubscriptionData.fromJson(jsonDecode(jsonString));
    return subscriptionData;
  }
}

finishIosTransaction() async {
  var transactions = await SKPaymentQueueWrapper().transactions();
  for (var transaction in transactions) {
    try {
      await SKPaymentQueueWrapper().finishTransaction(transaction).then((value) {
        debugPrint("transaction finished");
      });
    } catch (e) {
      debugPrint("transaction error is $e");
    }
  }
}

completeTransaction(PurchaseDetails purchase) async {
  try {
    await RepositoryDependencies.inAppPurchase.completePurchase(purchase);
    print('Pending purchase completed.');
  } catch (e) {
    print('Error completing pending purchase: $e');
  }
}