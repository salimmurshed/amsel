import 'package:amsel_flutter/data/repository/repository_dependencies.dart';
import 'package:flutter/material.dart';

import '../../../common/resources/routes.dart';
import '../../../main.dart';

handleNavigation() async {
  bool isOnboardedFirstTime = await RepositoryDependencies.onboardingData.isOnboardingFirstTime();

  if (isOnboardedFirstTime) {
    await RepositoryDependencies.onboardingData.setOnboardingFirstTime(value: false);
    navigateToRoute(RouteName.routeOnboarding, arguments: false);
  } else {
    navigateToRoute(RouteName.routeParentNavigation);
  }
}

void navigateToRoute(String routeName, {bool? arguments}) {
  BuildContext context = navigatorKey.currentState!.context;
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, arguments:  arguments, (route) => false);
  }
}