import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amsel_flutter/data/model/api_request_models/subscription_request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../common/resources/training_constants.dart';
import '../../../data/model/local_models/favourite_trainings.dart';
import '../../../data/model/local_models/training_details.dart';
import '../../../data/repository/local_products_repository.dart';
import '../../../data/repository/repository_dependencies.dart';
import '../../../data/repository/training_details_repository.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../../../services/share_preferences_services/training_data.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '../../subscription/bloc/subscription_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

part 'dashboard_bloc.freezed.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardWithInitialState> {
  List<String> focusList = [];
  TrainingData trainingData = RepositoryDependencies.trainingData;

  DashboardBloc() : super(DashboardWithInitialState.initial()) {
    on<FetchTrainingDetails>(_onFetchTrainingDetails);
    on<TriggerSliderUpdate>(_onTriggerSliderUpdate);
    on<FetchTrainingTypeLevelRangeList>(_onFetchTrainingTypeLevelRangeList);
    on<TriggerTypeLevelRangeSelection>(_onTriggerTypeLevelRangeSelection);
    on<FetchFocusList>(_onFetchFocusList);
    on<TriggerFocusSelection>(_onTriggerFocusSelection);
    on<FetchFavouriteTrainingList>(_onFetchFavouriteTrainingList);
    on<TriggerControllerOnChangedEvent>(_onTriggerControllerOnChangedEvent);
    on<TriggerAddToFavouriteTrainingEvent>(
        _onTriggerAddToFavouriteTrainingEvent);
    on<TriggerRemoveFromFavouriteEvent>(_onTriggerRemoveFromFavouriteEvent);
    on<TriggerToSetFavouriteTrainingDataEvent>(
        _onTriggerToSetFavouriteTrainingDataEvent);
    on<TriggerResetGoalEvent>(_onTriggerResetGoalEvent);
    on<TriggerRefresh>(_onTriggerRefresh);

  }

  FutureOr<void> _onFetchTrainingDetails(FetchTrainingDetails event,
      Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    DashboardDetailLists dashboardDetailLists =
        await TrainingDetailsRepository.fetchTrainingDetails();

    int leftFreeTraining = await checkForResetCount();
    bool hasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    int trainingCount = await RepositoryDependencies.appSettingsData.getTrainingCount();
    emit(state.copyWith(
        isLoading: false,
        selectedTypeDisplay: dashboardDetailLists.selectedType,
        selectedLevelDisplay: dashboardDetailLists.selectedLevel,
        selectedRangeDisplay: dashboardDetailLists.selectedRange,
        selectedFocusDisplay: dashboardDetailLists.selectedFocus,
        isRangeFocusVisible: dashboardDetailLists.isRangeFocusVisible,
        hasSubscription: hasSubscription,
        leftFreeTraining: leftFreeTraining,
        trainingCount: trainingCount,
        canStartFavTraining: false));
  }

  FutureOr<void> _onTriggerSliderUpdate(TriggerSliderUpdate event,
      Emitter<DashboardWithInitialState> emit) async {
    TrainingConstants.durationSeconds = event.seconds;
    emit(state.copyWith(minute: TrainingConstants.durationSeconds));
  }

  FutureOr<void> _onFetchTrainingTypeLevelRangeList(FetchTrainingTypeLevelRangeList event, Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isLoading: true));
    if (event.selectedMode == AppStrings.training_trainingType) {
      String selectedType = await trainingData.geTrainingType();
      String selectedTypeDisplay = await GetDashboardSelectedData.getTypeValue();
      emit(state.copyWith(
          isLoading: false,
          typeList: DashboardDetailsData.typeList,
          selectedType: selectedType,
          selectedTypeDisplay: selectedTypeDisplay)
      );
    } else if (event.selectedMode == AppStrings.training_trainingLevel) {
      String selectedLevel = await trainingData.getTrainingLevel();
      String selectedLevelDisplay =
          await GetDashboardSelectedData.getLevelValue();
      // debugPrint("selected level is $selectedLevel");
      emit(state.copyWith(
          isLoading: false,
          levelList: DashboardDetailsData.levelList,
          selectedLevel: selectedLevel,
          selectedLevelDisplay: selectedLevelDisplay));
    } else if (event.selectedMode == AppStrings.training_trainingRange) {
      String? selectedRange = await trainingData.getTrainingRange();
      String? selectedRangeDisplay =
          await GetDashboardSelectedData.getRangeValue();
      // debugPrint("selected range is $selectedRange");
      emit(state.copyWith(
          isLoading: false,
          rangeList: DashboardDetailsData.rangeList,
          selectedRangeDisplay: selectedRangeDisplay,
          selectedRange: selectedRange));
    }
  }

  FutureOr<void> _onTriggerTypeLevelRangeSelection(TriggerTypeLevelRangeSelection event, Emitter<DashboardWithInitialState> emit) async {
    if (event.selectedMode == AppStrings.training_trainingType) {
      await trainingData.seTrainingType(type: event.item.serverTitle);
      String type = await trainingData.geTrainingType();
      bool isRangeFocusVisible = false;
      // debugPrint("condition ${type != AppStrings.training_type_serverId_three || type != AppStrings.training_type_serverId_four}");
      if (type == AppStrings.training_type_serverId_three || type == AppStrings.training_type_serverId_four) {
        isRangeFocusVisible = true;
        focusList.clear();
        if(type == AppStrings.training_type_serverId_three) {
          await trainingData.setTrainingFocus(focus: '');
        } else {
          await trainingData.setTrainingFocus(focus: AppStrings.training_focus_serverId_one);
        }
      } else {
        await trainingData.setTrainingFocus(focus: "");
        await trainingData.setTrainingRange(
            range: AppStrings.training_range_serverId_one);
      }
      String? selectedFocus = await trainingData.getTrainingFocus();
      String selectedFocusDisplay =
          await GetDashboardSelectedData.getFocusValue();
      emit(state.copyWith(
          isLoading: false,
          selectedTypeDisplay: event.item.title,
          selectedFocus: selectedFocus,
          selectedFocusDisplay: selectedFocusDisplay,
          isRangeFocusVisible: isRangeFocusVisible));
      Navigator.pop(navigatorKey.currentContext!);
    } else if (event.selectedMode == AppStrings.training_trainingLevel) {
      await trainingData.setTrainingLevel(level: event.item.serverTitle);
      emit(state.copyWith(
          isLoading: false, selectedLevelDisplay: event.item.title));
      Navigator.pop(navigatorKey.currentContext!);
    } else if (event.selectedMode == AppStrings.training_trainingRange) {
      await trainingData.setTrainingRange(range: event.item.serverTitle);
      emit(state.copyWith(
          isLoading: false, selectedRangeDisplay: event.item.title));
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  FutureOr<void> _onFetchFocusList(FetchFocusList event, Emitter<DashboardWithInitialState> emit) async {
    String? selectedFocus = await trainingData.getTrainingFocus();
    String selectedFocusDisplay =
        await GetDashboardSelectedData.getFocusValue();
    debugPrint("Focus is $selectedFocus");
    focusList = selectedFocus.split(", ");
    debugPrint("list is ${focusList.toList().toString()} lenght is ${focusList.length}");
    selectedFocus = focusList.toList().toString().replaceAll("[", "").replaceAll("]", "");

    List<DashboardMenuModel> displayFocusList = [];
    displayFocusList.addAll(DashboardDetailsData.focusList);
    String type = await trainingData.geTrainingType();
    debugPrint("selectedFocus ${state.selectedTypeDisplay} and $type and ${AppStrings.training_type_serverId_four}");
    if(type == AppStrings.training_type_serverId_four){
      int index = displayFocusList.indexWhere((element)=> element.id == 0);
      debugPrint("index is $index");
      if(index >= 0){
        displayFocusList.removeAt(0);
      }
    }
    emit(state.copyWith(
        isLoading: false,
        focusList: displayFocusList,
        selectedFocusDisplay: selectedFocusDisplay,
        selectedFocus: selectedFocus,
        selectedFocusList: focusList));
  }

  FutureOr<void> _onTriggerFocusSelection(TriggerFocusSelection event, Emitter<DashboardWithInitialState> emit) async {
    String selectedType = await trainingData.geTrainingType();
    if (selectedType == AppStrings.training_type_serverId_four) {
      await trainingData.setTrainingFocus(focus: event.item.serverTitle);
      var selectedFocusDisplay = await GetDashboardSelectedData.getFocusValue();
      emit(state.copyWith(
          isLoading: false,
          selectedFocus: event.item.title,
          selectedFocusDisplay: selectedFocusDisplay));
      String selectedFocus = await trainingData.getTrainingFocus();
      // debugPrint("selected focus is $selectedFocus");
      Navigator.pop(navigatorKey.currentContext!);
    } else {
      debugPrint("event item is ${event.item.serverTitle} and id ${event.item.id}");
      debugPrint("before focus list is ${focusList.toList().toString()}");
      if(event.item.id == 0 || focusList.isEmpty){
        focusList = [AppStrings.training_focus_serverId_zero];
      } else {
        if(focusList.contains(AppStrings.training_focus_serverId_zero)){
          focusList.clear();
        }
        if (focusList.contains(event.item.serverTitle)) {
          focusList.remove(event.item.serverTitle);
        } else {
          if (focusList.length < 2) {
            focusList.add(event.item.serverTitle);
          } else {
            Toast.nullableIconToast(message: AppLocalizations.of(navigatorKey.currentContext!)!.max_training_focus_validation, isErrorBooleanOrNull: null);
          }
        }

      }

      if (focusList.isEmpty) {
        focusList = [AppStrings.training_focus_serverId_one];
      }

      // if(focusList.contains(AppStrings.training_focus_serverId_one)){
      //   focusList = [AppStrings.training_focus_serverId_one];
      // }

      var selectedFocus = focusList.toList().toString().replaceAll("[", "").replaceAll("]", "");
      await trainingData.setTrainingFocus(focus: selectedFocus);
      var selectedFocusDisplay = await GetDashboardSelectedData.getFocusValue();
      debugPrint("after focus list is ${focusList.toList().toString()}");
      emit(state.copyWith(
          isLoading: false,
          selectedFocus: selectedFocus,
          selectedFocusList: focusList,
          selectedFocusDisplay: selectedFocusDisplay));
    }
  }

  FutureOr<void> _onFetchFavouriteTrainingList(FetchFavouriteTrainingList event, Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isFavLoading: true));
    List<FavouriteTrainings> favouriteTrainings =
        await LocalTrainingRepository.fetchFavouriteProducts();
    // debugPrint("local product length ${favouriteTrainings.length}");
    favouriteTrainings.sort((b, a) => a.date.compareTo(b.date));
    emit(state.copyWith(
        isFavLoading: false, favouriteTrainings: favouriteTrainings));
  }

  FutureOr<void> _onTriggerControllerOnChangedEvent(
      TriggerControllerOnChangedEvent event,
      Emitter<DashboardWithInitialState> emit) async {
    int length = event.textEditingController.text.length;
    emit(state.copyWith(textLength: length));
  }

  FutureOr<void> _onTriggerAddToFavouriteTrainingEvent(
      TriggerAddToFavouriteTrainingEvent event,
      Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isFavLoading: true));
    String type = await GetDashboardSelectedData.getTypeValue();
    String level = await GetDashboardSelectedData.getLevelValue();
    String range = await GetDashboardSelectedData.getRangeValue();
    String focus =
        await GetDashboardSelectedData.getFocusValue(isForFavourite: true);
    String typeServerId =
        await RepositoryDependencies.trainingData.geTrainingType();
    String levelServerId =
        await RepositoryDependencies.trainingData.getTrainingLevel();
    String rangeServerId =
        await RepositoryDependencies.trainingData.getTrainingRange();
    String focusServerId =
        await RepositoryDependencies.trainingData.getTrainingFocus();
    // debugPrint("type $type level $level range $range \nfocus $focus");
    // debugPrint("typeServerId $typeServerId levelServerId $levelServerId rangeServerId $rangeServerId focusServerId $focusServerId");
    await LocalTrainingRepository.addFavouriteProduct(
        date: DateTime.now(),
        title: state.textEditingController.text,
        duration: TrainingConstants.durationSeconds,
        type: type,
        level: level,
        range: range,
        focus: focus,
        typeServerId: typeServerId,
        levelServerId: levelServerId,
        rangeServerId: rangeServerId,
        focusServerId: focusServerId);
    // Toast.nullableIconToast(message: "Training added as favourite", isErrorBooleanOrNull: false);
    List<FavouriteTrainings> favouriteTrainings =
        await LocalTrainingRepository.fetchFavouriteProducts();
    emit(state.copyWith(
        isFavLoading: false,
        favouriteTrainings: favouriteTrainings,
        textEditingController: TextEditingController()));
  }

  FutureOr<void> _onTriggerRemoveFromFavouriteEvent(
      TriggerRemoveFromFavouriteEvent event,
      Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isFavLoading: true));
    await LocalTrainingRepository.deleteFavouriteProduct(
        trainingId: event.trainingId);
    List<FavouriteTrainings> favouriteTrainings =
        await LocalTrainingRepository.fetchFavouriteProducts();
    emit(state.copyWith(
        isFavLoading: false, favouriteTrainings: favouriteTrainings));
  }

  FutureOr<void> _onTriggerToSetFavouriteTrainingDataEvent(
      TriggerToSetFavouriteTrainingDataEvent event,
      Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(canStartFavTraining: true, isLoading: true));
    await trainingData.seTrainingType(type: event.trainingId.typeServerId);
    await trainingData.setTrainingLevel(level: event.trainingId.levelServerId);
    await trainingData.setTrainingRange(range: event.trainingId.rangeServerId);
    await trainingData.setTrainingFocus(focus: event.trainingId.focusServerId);
    TrainingConstants.durationSeconds = event.trainingId.duration;
    DashboardDetailLists dashboardDetailLists =
        await TrainingDetailsRepository.fetchTrainingDetails();
    emit(state.copyWith(
      isLoading: false,
      canStartFavTraining: false,
      selectedType: dashboardDetailLists.selectedType,
      selectedLevel: dashboardDetailLists.selectedLevel,
      selectedRange: dashboardDetailLists.selectedRange,
      selectedFocus: dashboardDetailLists.selectedFocus,
      isRangeFocusVisible: dashboardDetailLists.isRangeFocusVisible,
      minute: TrainingConstants.durationSeconds,
    ));
  }

  FutureOr<void> _onTriggerResetGoalEvent(TriggerResetGoalEvent event,
      Emitter<DashboardWithInitialState> emit) async {
    emit(
        state.copyWith(isRefresh: true, trainingCount: 0, leftFreeTraining: 0));
    int count = 0, leftCount = 0;
    count = await RepositoryDependencies.appSettingsData.getTrainingCount();
    leftCount =
        await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
    bool hasSubscription =
        await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    emit(state.copyWith(
        isRefresh: false,
        trainingCount: count,
        leftFreeTraining: leftCount,
        hasSubscription: hasSubscription));
  }

  checkForResetCount() async {
    int leftFreeTraining =
        await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
    bool hasSubscription =
        await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    String? lastResetDate =
        await RepositoryDependencies.appSettingsData.getTrainingCountRest();
    String? jsonString =
        await RepositoryDependencies.appSettingsData.getUserSubscription();
    if (lastResetDate != null) {
      DateTime now = DateTime.now();
      DateTime todayDateOnly = DateTime(now.year, now.month, now.day);
      DateTime lastRelease = DateTime.parse(lastResetDate);
      DateTime lastReleaseDateOnly =
          DateTime(lastRelease.year, lastRelease.month, lastRelease.day);
      bool areDatesEqual = todayDateOnly == lastReleaseDateOnly;
      debugPrint(
          "today date is $todayDateOnly, last release date is $lastReleaseDateOnly and areDatesEqual is $areDatesEqual");
      if (DateTime.now().weekday == DateTime.monday && !areDatesEqual) {
        await RepositoryDependencies.appSettingsData
            .setLeftTrainingCount(value: 0);
        leftFreeTraining =
            await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
        await RepositoryDependencies.appSettingsData
            .setTrainingCountReset(value: now.toString());
      } else {
        leftFreeTraining =
            await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
      }
    }
    if (jsonString != null && jsonString.isNotEmpty) {


      if(Platform.isIOS){

        SubscriptionData? currentSubscription;
        debugPrint("Subscription is $jsonString");
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        currentSubscription = SubscriptionData.fromJson(jsonMap);
        debugPrint("Current subscription is $currentSubscription");
        DateTime purchaseExpiry = getUTCTime(expiryDate: currentSubscription.expiryDate!.toString());
        DateTime currentDate = DateTime.now().toUtc();
        debugPrint("purchaseExpiry is $purchaseExpiry and currentDate is $currentDate condition is ${purchaseExpiry.isBefore(currentDate)}");
        if(purchaseExpiry.isBefore(currentDate)){
            leftFreeTraining = await RepositoryDependencies.appSettingsData.getLeftTrainingCount();
            await RepositoryDependencies.appSettingsData.setTrainingCount(value: 3);
            await RepositoryDependencies.appSettingsData.setSubscriptionHasSubscription(value: false);
            await RepositoryDependencies.appSettingsData.setUserSubscription(jsonEncodedValue: "");
            return leftFreeTraining;
        } else {
            leftFreeTraining = await RepositoryDependencies.appSettingsData
                .getLeftTrainingCount();
            return leftFreeTraining;
        }
      } else {
       List<GooglePlayPurchaseDetails> googlePlayPurchaseDetails = await getPastPurchases();
       if(googlePlayPurchaseDetails.isEmpty){
             await RepositoryDependencies.appSettingsData.setTrainingCount(value: 3);
             await RepositoryDependencies.appSettingsData.setSubscriptionHasSubscription(value: false);
             await RepositoryDependencies.appSettingsData.setUserSubscription(jsonEncodedValue: "");
             return leftFreeTraining;
       } else {
             leftFreeTraining = await RepositoryDependencies.appSettingsData
                 .getLeftTrainingCount();
             return leftFreeTraining;
       }
      }

    } else {
      await RepositoryDependencies.appSettingsData.setTrainingCount(value: 3);
    }
    return leftFreeTraining;
  }

  FutureOr<void> _onTriggerRefresh(TriggerRefresh event, Emitter<DashboardWithInitialState> emit) async {
    emit(state.copyWith(isRefresh: true));
    bool hasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
    emit(state.copyWith(isRefresh: false, hasSubscription: hasSubscription));
  }
}
