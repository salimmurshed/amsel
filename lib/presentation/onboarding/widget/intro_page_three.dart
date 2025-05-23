import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/widgets/build_intro_image.dart';
import 'icon_text_widget.dart';

class IntroPageThree extends StatelessWidget {
  const IntroPageThree({super.key,});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildIntroImage(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHPadding),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.onBoarding_introPageThree_title_partOne,
                          style: Style.pageHeaderStyle(), textAlign: TextAlign.center),
                      Text(AppLocalizations.of(context)!
                          .onBoarding_introPageThree_title_partTwo,
                        style: Style.pageHeaderStyle(
                            colorBG: AppColor.colorPrimaryBG),
                        textAlign: TextAlign.center,
                      ),
                      Text(AppLocalizations.of(context)!.onBoarding_introPageThree_infoOne,
                          textAlign: TextAlign.center, style: Style.descTextStyle()),
                      SizedBox(height: widgetBottomPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: iconTextWidget(
                                    svgPath: Assets.icStarHalf,
                                    text: AppLocalizations.of(context)!.training_level_title_one)),
                            SizedBox(width: 30.w),
                            Expanded(
                                child: iconTextWidget(
                                    svgPath: Assets.icStar,
                                    text: AppLocalizations.of(context)!.training_level_title_two))
                          ],
                        ),
                      ),
                      SizedBox(height: menuCardVerticalPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: iconTextWidget(
                                    svgPath: Assets.icStarHalfBorder,
                                    text: AppLocalizations.of(context)!.training_level_title_three)),
                            SizedBox(width: 30.w),
                            Expanded(
                                child: iconTextWidget(
                                    svgPath: Assets.icStarFill,
                                    text: AppLocalizations.of(context)!.training_level_title_four))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: widgetBottomPadding),
                        child:  Text(AppLocalizations.of(context)!.onBoarding_introPageThree_infoTwo,
                            textAlign: TextAlign.center, style: Style.descTextStyle()),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: widgetBottomPadding, horizontal: 40.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: iconTextWidget(
                                    svgPath: Assets.icDownArrow,
                                    isArrow: true,
                                    text: AppLocalizations.of(context)!.training_range_title_one)),
                            SizedBox(width: 30.w),
                            Expanded(
                                child: iconTextWidget(
                                  isArrow: true,
                                    svgPath: Assets.icUpArrow,
                                    text: AppLocalizations.of(context)!.training_range_title_two))
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Style.descTextStyle(),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.onBoarding_introPageThree_infoTwo_partOne,
                              style: Style.descTextBoldStyle(),
                            ),
                            TextSpan(
                                text: AppLocalizations.of(context)!.onBoarding_introPageThree_infoTwo_partTwo,
                                style: Style.descTextStyle()),
                          ],
                        ),
                      ),
                      SizedBox(height: widgetBottomPadding),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
