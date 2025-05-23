import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../../../common/widgets/build_intro_image.dart';
import 'icon_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroPageTwo extends StatelessWidget {
  const IntroPageTwo({super.key, });


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
                      Text(AppLocalizations.of(context)!.onBoarding_introPageTwo_title_partOne,
                          style: Style.pageHeaderStyle(), textAlign: TextAlign.center),
                      Text(AppLocalizations.of(context)!.onBoarding_introPageTwo_title_partTwo,
                        style: Style.pageHeaderStyle(colorBG: AppColor.colorPrimaryBG),
                        textAlign: TextAlign.center,
                      ),
                      Text(AppLocalizations.of(context)!.onBoarding_introPageTwo_info,
                          textAlign: TextAlign.center, style: Style.descTextStyle()),
                      SizedBox(height: widgetBottomPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: iconTextWidget(
                                  imagePath: Assets.icAtmen,
                                text: AppLocalizations.of(context)!.training_type_title_one
                              ),
                            ),
                            SizedBox(width: 30.w),
                            Expanded(
                              child: iconTextWidget(
                                  svgPath: Assets.icMic,
                                text: AppLocalizations.of(context)!.training_type_title_two
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: menuCardVerticalPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: iconTextWidget(
                                  imagePath: Assets.icEins,
                                text: AppLocalizations.of(context)!.training_type_title_three
                              ),
                            ),
                            SizedBox(width: 30.w),
                            Expanded(
                              child: iconTextWidget(
                                  svgPath: Assets.icStar,
                                text: AppLocalizations.of(context)!.training_type_title_four
                              ),
                            )
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
