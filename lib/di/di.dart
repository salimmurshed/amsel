import 'package:amsel_flutter/presentation/app_settings/bloc/app_setting_bloc.dart';
import 'package:amsel_flutter/presentation/contact-us/bloc/contact_us_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/local_data_service/product_database_services.dart';
import '../presentation/contact-us/usecase/contact_us_usecase.dart';
import '../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../presentation/navigator/bloc/navigators_bloc.dart';
import '../presentation/onboarding/bloc/onboarding_bloc.dart';
import '../presentation/splash/bloc/splash_bloc.dart';
import '../presentation/statistics/bloc/statistic_bloc.dart';
import '../presentation/subscription/bloc/subscription_bloc.dart';
import '../presentation/training/bloc/training_bloc.dart';
import '../presentation/training/usecase/training_usecase.dart';
import '../presentation/weekly_goal/bloc/weekly_goal_bloc.dart';
import '../services/http_services/http_connection_info_services.dart';
import '../services/isar_db_services/isar_db_instance/isar_helpers.dart';
import '../services/share_preferences_services/app_settings_data.dart';
import '../services/share_preferences_services/onboarding_data.dart';
import '../services/share_preferences_services/training_data.dart';

final instance = GetIt.instance;
//init modules should register corresponding repository, services, and blocs
Future<void> initAppModule() async {
  instance.registerLazySingleton<HttpConnectionInfoServices>(
      () => HttpConnectionEstablishment());
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  IsarHelpers isarHelpers = IsarHelpers();
  instance.registerLazySingleton<IsarHelpers>(() => isarHelpers);
  instance.registerLazySingleton<TrainingDataBaseSource>(
      () => TrainingDataBaseSource());
  instance
      .registerLazySingleton<OnboardingData>(() => OnboardingData(instance()));
  instance.registerLazySingleton<AppSettingsData>(
      () => AppSettingsData(instance()));
  instance.registerLazySingleton<TrainingData>(() => TrainingData(instance()));
  InAppPurchase inAppPurchase = InAppPurchase.instance;
  instance.registerLazySingleton<InAppPurchase>(() => inAppPurchase);
  AudioPlayer audioPlayer = AudioPlayer();
  instance.registerLazySingleton<AudioPlayer>(() => audioPlayer);

  // Register AudioHandler
  // instance.registerSingleton<AudioHandler>(await AudioService.init(
  //   builder: () => AudioPlayerHandlerImpl(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   ),
  // ));

  // instance.registerLazySingleton<AudioPlayerHandler>(() => AudioPlayerHandlerImpl());
  // Register AudioHandler using AudioPlayerHandlerImpl



  // Register the audio handler with GetIt

  initSplashModule();
  initTrainingModule();
} //For entire app

Future<void> setup() async {
  // Initialize the audio handler

  // Register BLoC
}

Future<void> initSplashModule() async {
  if (!GetIt.I.isRegistered<SplashBloc>()) {
    instance.registerFactory<SplashBloc>(() => SplashBloc());
  }
} //For splash screen

Future<void> initOnboardingModule() async {
  if (!GetIt.I.isRegistered<OnboardingBloc>()) {
    instance.registerFactory<OnboardingBloc>(() => OnboardingBloc());
  }
} // For Onboarding Screen

Future<void> initNavigatorModule() async {
  if (!GetIt.I.isRegistered<NavigatorsBloc>()) {
    instance.registerFactory<NavigatorsBloc>(() => NavigatorsBloc());
  }
  if (!GetIt.I.isRegistered<DashboardBloc>()) {
    instance.registerFactory<DashboardBloc>(() => DashboardBloc());
  }
  // if (!GetIt.I.isRegistered<MyAccountBloc>()) {
  //   instance.registerFactory<MyAccountBloc>(
  //           () => MyAccountBloc());
  // }
} // For Navigation Screen

Future<void> initSubscriptionModule() async {
  if (!GetIt.I.isRegistered<SubscriptionBloc>()) {
    instance.registerFactory<SubscriptionBloc>(() => SubscriptionBloc());
  }
} // For Subscription Screen

Future<void> initTrainingModule() async {
  if (!GetIt.I.isRegistered<TrainingUseCase>()) {
    instance.registerFactory<TrainingUseCase>(() => TrainingUseCase());
  }
  if (!GetIt.I.isRegistered<TrainingBloc>()) {
    instance.registerFactory<TrainingBloc>(() => TrainingBloc(instance()));
  }
}

Future<void> initStatisticModule() async {
  if (!GetIt.I.isRegistered<StatisticBloc>()) {
    instance.registerFactory<StatisticBloc>(() => StatisticBloc());
  }
}

Future<void> initAppSettingModule() async {
  if (!GetIt.I.isRegistered<AppSettingBloc>()) {
    instance.registerFactory<AppSettingBloc>(() => AppSettingBloc());
  }
}

Future<void> initWeeklyGoalSettingModule() async {
  if (!GetIt.I.isRegistered<WeeklyGoalBloc>()) {
    instance.registerFactory<WeeklyGoalBloc>(() => WeeklyGoalBloc());
  }
}

Future<void> initContactUsModule() async {
  if (!GetIt.I.isRegistered<ContactUsUseCase>()) {
    instance.registerFactory<ContactUsUseCase>(() => ContactUsUseCase());
  }
  if (!GetIt.I.isRegistered<ContactUsBloc>()) {
    instance.registerFactory<ContactUsBloc>(() => ContactUsBloc(instance()));
  }
}
