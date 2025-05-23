import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../imports/common.dart';
import '../../../common/widgets/build_intro_image.dart';

class IntroPageOne extends StatelessWidget {
  const IntroPageOne({super.key, });



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //padding: EdgeInsets.symmetric(horizontal: screenHPadding),
      child: Column(
        children: [
          buildIntroImage(),
          Text(
              AppLocalizations.of(context)!
                  .onBoarding_introPageOne_title_partOne,
              textAlign: TextAlign.center,
              style: Style.headerStyle()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenHPadding),
            child: Column(
              children: [RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .onBoarding_introPageOne_title_partTwo,
                        style: Style.titleSemiBoldStyle(hight: 0)),
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .onBoarding_introPageOne_title_partThree,
                      style: Style.titleSemiBoldStyle(
                          hight: 0, colorBG: AppColor.colorPrimaryBG),
                    ),
                  ],
                ),
              ),
                SizedBox(height: widgetBottomPadding),
                Text(AppLocalizations.of(context)!.onBoarding_introPageOne_subTitle,
                    textAlign: TextAlign.center, style: Style.descTextStyle()),
                SizedBox(height: menuCardVerticalPadding),
                Text(AppLocalizations.of(context)!.onBoarding_introPageOne_info,
                    textAlign: TextAlign.center, style: Style.descTextStyle()),
                SizedBox(height: generalPadding),
                ImageView(
                    imagePath: Assets.imgIntroPageOne,
                    fit: BoxFit.cover,
                    width: introContainerWidth),
                SizedBox(height: widgetBottomPadding)],
            ),
          )
        ],
      ),
    );
  }
}
