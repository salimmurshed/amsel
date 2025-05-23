import 'package:amsel_flutter/di/di.dart';
import 'package:amsel_flutter/presentation/app_settings/page/app_infomation_view.dart';
import 'package:amsel_flutter/presentation/app_settings/page/push_notification_view.dart';
import 'package:amsel_flutter/presentation/subscription/page/subscription_view.dart';
import 'package:flutter/material.dart';
import '../../app_configuration/app_environments.dart';
import '../../presentation/contact-us/page/contact_us_view.dart';
import '../../presentation/navigator/page/navigator_view.dart';
import '../../presentation/onboarding/page/onboarding_view.dart';
import '../../presentation/splash/page/splash_view.dart';
import '../../presentation/training/page/training_view.dart';
import '../../presentation/weekly_goal/page/weekly_goal_view.dart';
import 'app_strings.dart';

class RouteName {
  //property owner
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding-route';
  static const String routeParentNavigation = '/navigation-route';
  static const String routeDashboard = '/dashboard-route';
  static const String routeTrainingTypeLevelRange =
      '/training-level-range-type-route';
  static const String routeTrainingFocus = '/training-focus-route';
  static const String routeMyAccount = '/my-account-route';
  static const String routeTraining = '/training-route';
  static const String routeSubscription = '/subscription-route';
  static const String routePushNotification = '/push-notification-route';
  static const String routeAppInformation = '/AppInformation-route';
  static const String routeSetWeeklyGoal = '/set-weekly-goal-route';
  static const String routeContactUs = '/contact-us-route';
}

class Routes {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    // final Arguments args = routeSettings.arguments as Arguments;
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case RouteName.routeSplash:
        initSplashModule();
        return MaterialPageRoute(builder: (_) => const SplashView());
      case RouteName.routeOnboarding:
        initOnboardingModule();
        return MaterialPageRoute(
            builder: (_) => OnboardingView(isFromSettings: args as bool));
      case RouteName.routeParentNavigation:
        initNavigatorModule();
        initStatisticModule();
        initSubscriptionModule();
        return MaterialPageRoute(builder: (_) => const NavigatorView());
      case RouteName.routeSubscription:
        initSubscriptionModule();
        return MaterialPageRoute(builder: (_) => const SubscriptionView());
      case RouteName.routeTraining:
        initTrainingModule();
        return MaterialPageRoute(builder: (_) => const TrainingView());
      case RouteName.routePushNotification:
        initAppSettingModule();
        return MaterialPageRoute(builder: (_) => const PushNotificationView());
      case RouteName.routeAppInformation:
        initAppSettingModule();
        return MaterialPageRoute(builder: (_) => const AppInformationView());
      case RouteName.routeSetWeeklyGoal:
        initWeeklyGoalSettingModule();
        return MaterialPageRoute(builder: (_) => const WeeklyGoalView());
      case RouteName.routeContactUs:
        initContactUsModule();
        return MaterialPageRoute(builder: (_) => const ContactUsView());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppEnvironments.appName),
              ),
              body: const Center(
                child: Text(AppStrings.routName_defaultRoute_title),
              ),
            ));
  }
}
