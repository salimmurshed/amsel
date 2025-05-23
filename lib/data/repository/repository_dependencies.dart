import 'dart:async';
import 'package:amsel_flutter/services/share_preferences_services/onboarding_data.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:just_audio/just_audio.dart';
import '../../di/di.dart';
import '../../services/http_services/http_connection_info_services.dart';
import '../../services/share_preferences_services/app_settings_data.dart';
import '../../services/share_preferences_services/training_data.dart';

class RepositoryDependencies {
  static final OnboardingData onboardingData = instance<OnboardingData>();
  static final AppSettingsData appSettingsData = instance<AppSettingsData>();
  static final TrainingData trainingData = instance<TrainingData>();
  static final InAppPurchase inAppPurchase = instance<InAppPurchase>();
  static StreamSubscription<List<PurchaseDetails>> streamSubscription = instance<StreamSubscription<List<PurchaseDetails>>>();
  static final HttpConnectionInfoServices httpConnectionInfo = instance<HttpConnectionInfoServices>();
  static final AudioPlayer audioPlayer = instance<AudioPlayer>();
}
