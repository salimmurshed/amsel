import 'package:amsel_flutter/app_configuration/app_environments.dart';
import 'package:amsel_flutter/common/resources/enum.dart';
import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:amsel_flutter/di/di.dart';
import 'package:amsel_flutter/presentation/app_settings/bloc/app_setting_bloc.dart';
import 'package:amsel_flutter/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:amsel_flutter/presentation/statistics/bloc/statistic_bloc.dart';
import 'package:amsel_flutter/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:amsel_flutter/presentation/training/bloc/training_bloc.dart';
import 'package:amsel_flutter/services/isar_db_services/isar_db_instance/isar_helpers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'common/functions/other.dart';
import 'common/resources/app_color.dart';
import 'common/resources/routes.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'presentation/training/bloc/audio_player_handler.dart';
bool isTablet = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final botToastBuilder = BotToastInit();
late AudioPlayerHandler audioPlayerHandler;
Future<void> mainDelegateForEnvironments() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationService.initialize();
  // await FirebaseCloudMessage().setUpNotificationServiceForOS(isCalledFromBg: true);

  await ScreenUtil.ensureScreenSize();
  await IsarHelpers.initializeDatabase();
  runApp(RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp._internal();

  static const RootApp instance = RootApp._internal();

  factory RootApp() => instance;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    // ]);
    audioPlayerHandlerFunction(); //Initialize at initState

    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _setOrientation();


  }

  void audioPlayerHandlerFunction () async {
    audioPlayerHandler = await AudioService.init(
      builder: () => AudioPlayerHandlerImpl(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: true, // Should stop the foreground service
      ),
    );
  }

  void _setOrientation() {if (MediaQuery.of(context).size.shortestSide >= 600) {
    // Device is a tablet
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //could set landscape if needed in future
    ]);
    isTablet = true;
  } else {
    // Device is a phone
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    isTablet = false;
  }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(create: (context) => instance<DashboardBloc>()),
        BlocProvider<StatisticBloc>(create: (context) => instance<StatisticBloc>()),
        BlocProvider<TrainingBloc>(create: (context) => instance<TrainingBloc>()),
        BlocProvider<AppSettingBloc>(create: (context) => instance<AppSettingBloc>()),
        BlocProvider<SubscriptionBloc>(create: (context) => instance<SubscriptionBloc>()),
        // BlocProvider<SubscriptionBloc>(
        //   create: (context) => instance<SubscriptionBloc>()..add(InitializeInAppPurchase()),
        // ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // locale: AppEnvironments.environments == Environment.dev ? Locale('de') : getLocale(),
        locale: getLocale(),
        supportedLocales: const [
          Locale('en'), // English
          Locale('de'), // German
        ],
        debugShowCheckedModeBanner: AppEnvironments.debugBannerBoolean,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppColor.colorWhite
        ),
        builder: (ctx, child) {
          ScreenUtil.init(ctx);
          child = botToastBuilder(context, child);
          return ResponsiveBreakpoints.builder(child: child, breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ]);
        },
        initialRoute: RouteName.routeSplash,
        onGenerateRoute: Routes.getRoute,
        title: AppEnvironments.appName,
        // home: AudioServiceExample()
      ),
    );
  }
}


// getNotification() async {
//   bool isUserHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
//   // debugPrint("isUserHasSubscription $isUserHasSubscription");
//   final now = DateTime.now();
//   if(isUserHasSubscription) {
//     if (now.weekday == DateTime.thursday && now.hour == 8) {
//       int trainingCount = await RepositoryDependencies.appSettingsData
//           .getTrainingCount();
//       int completedTrainingCount = await getTrainingsThisWeek();
//       if (trainingCount > completedTrainingCount) {
//         await NotificationService.showSimpleNotification(isForPaidUser: true);
//       }
//     }
//   } else {
//     if (now.weekday == DateTime.monday && now.hour == 8) {
//       await NotificationService.showSimpleNotification(isForPaidUser: isUserHasSubscription);
//     }
//   }
// }
//
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   String jsonString = message.data['notification'] ?? 'Hello';
//   // Parse JSON
//   Map<String, dynamic> jsonData = jsonDecode(jsonString);
//   // Extract title
//   String title = jsonData['title'] ?? 'Hello';
//   String body = jsonData['body'] ?? 'Hello';
//   String payload = jsonEncode(message.data);
//   FirebaseCloudMessage firebaseCloudMessage = FirebaseCloudMessage();
//   await firebaseCloudMessage.setUpNotificationServiceForOS(
//       isCalledFromBg: true);
//   await firebaseCloudMessage.showNotification(title, body, payload);
//   await Firebase.initializeApp();
//   return;
// }