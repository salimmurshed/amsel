import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/repository/repository_dependencies.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../bloc/splash_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashBloc splashBloc = instance<SplashBloc>();

  @override
  void initState() {
    setAlarmForNotification();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => splashBloc..add(TriggerSplashScreenOpen()),
      child: BlocListener<SplashBloc, SplashInitialState>(
        listener: (context, state) {
          if (state.isDelayCompleted) {
            // splashBloc.add(TriggerNavigation());
          }
        },
        child: BlocBuilder<SplashBloc, SplashInitialState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.colorPrimary,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 41.w),
                  child: const ImageView(
                    imagePath: Assets.imgAppLauncher,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> setAlarmForNotification() async {
  // await cancelAllTasks();

  bool isUserHasSubscription = await RepositoryDependencies.appSettingsData.isUserHasSubscription();
  debugPrint("Splash isUserHasSubscription $isUserHasSubscription");
  // Workmanager().registerPeriodicTask(
  //   "1",
  //   "weeklyTask",
  //   frequency: const Duration(days: 7),
  //   initialDelay: getInitialDelay(isForPaidUser: isUserHasSubscription),
  // );


}
