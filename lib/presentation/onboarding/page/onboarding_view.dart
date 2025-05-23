import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../main.dart';
import '../bloc/onboarding_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key, required this.isFromSettings});
  final bool isFromSettings;
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController pageController = PageController();

  final OnboardingBloc onBoardingBloc = instance<OnboardingBloc>();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    });
    return Scaffold(
      body: BlocProvider(
        create: (context) => onBoardingBloc
          ..add(OnBoardPageControllerUpdate(pageController: pageController, currentIndex: 0)),
        child: BlocBuilder<OnboardingBloc, OnboardingInitialState>(
          builder: (context, state) {
            return Column(
              children: [

                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        onPageChanged: (i) {
                          onBoardingBloc.add(OnBoardPageControllerUpdate(
                            currentIndex: i,
                              pageController: pageController));
                        },
                        controller: pageController,
                        itemCount: state.introPageList.length,
                        itemBuilder: (context, index) {
                          return state.introPageList[index];
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        bottom: widgetBottomPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                                effect: WormEffect(
                                  activeDotColor: AppColor.colorPrimary,
                                  dotColor: AppColor.colorLightGrey,
                                ),
                                controller: pageController,
                                count: 5),
                            SizedBox(width: 40.w),
                            CustomButton(
                              height:  32.h,
                                buttonSize: ButtonSize.medium,
                                width: 94.w,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,),
                                variant: ButtonVariant.btnPrimary,
                                text: AppLocalizations.of(context)!
                                    .onBoarding_nextBtn,
                              onTap: () async {
                                  if(state.currentIndex == 4){
                                    // debugPrint("Last Page Go Next");
                                    widget.isFromSettings
                                        ? Navigator.pop(context)
                                        : Navigator.pushNamedAndRemoveUntil(context, RouteName.routeParentNavigation, (route) => false);
                                  } else {
                                    onBoardingBloc.add(
                                        TriggerOnBoardPageNextPage(
                                            pageController: pageController));
                                  }
                              },
                            )
                          ],
                        ),
                      ],
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
