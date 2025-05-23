import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../../../common/widgets/build_intro_image.dart';
import 'icon_text_widget.dart';

class IntroPageFour extends StatelessWidget {
  const IntroPageFour({super.key, });

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
                 child: Column(children: [
                   Text(AppLocalizations.of(context)!.onBoarding_introPageFour_title_partOne,
                       style: Style.pageHeaderStyle(), textAlign: TextAlign.center),
                   Text(AppLocalizations.of(context)!
                       .onBoarding_introPageFour_title_partTwo ,
                     style: Style.pageHeaderStyle(
                         colorBG: AppColor.colorPrimaryBG),
                     textAlign: TextAlign.center,
                   ),
                   RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(
                       children: [
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoOne_partOne,
                           style: Style.descTextStyle(),
                         ),
                         TextSpan(
                             text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoOne_partTwo,
                             style: Style.descTextBoldStyle()),
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoOne_partThree,
                           style: Style.descTextStyle(),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: widgetBottomPadding),
                   RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(
                       children: [
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoTwo_partOne,
                           style: Style.descTextStyle(),
                         ),
                         TextSpan(
                             text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoTwo_partTwo,
                             style: Style.descTextBoldStyle()),
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoTwo_partThree,
                           style: Style.descTextStyle(),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: widgetBottomPadding),
                   // Text(AppLocalizations.of(context)!.onBoarding_introPageFour_infoThree,
                   //     textAlign: TextAlign.center, style: Style.descTextStyle()),
                   RichText(
                     textAlign: TextAlign.center,
                     text: TextSpan(
                       children: [
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoThree_partOne,
                           style: Style.descTextStyle(),
                         ),
                         TextSpan(
                             text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoThree_partTwo,
                             style: Style.descTextBoldStyle()),
                         TextSpan(
                           text: AppLocalizations.of(context)!.onBoarding_introPageFour_infoThree_partThree,
                           style: Style.descTextStyle(),
                         ),
                       ],
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.symmetric(vertical: widgetBottomPadding, horizontal: 30.w),
                     child: Row(
                       children: [
                         Expanded(child: iconTextWidget(
                             svgPath: Assets.icCircleRing,
                             text: AppLocalizations.of(context)!.onBoarding_introPageFour_icon_text_one
                         )),
                         SizedBox(width: 30.w),
                         Expanded(child: iconTextWidget(
                             svgPath: Assets.icCircleRing,
                             text: AppLocalizations.of(context)!.onBoarding_introPageFour_icon_text_Two
                         )),
                       ],
                     ),
                   ),
                   iconTextWidget(
                       isOnlyOne: true,
                       svgPath: Assets.icCircleRing,
                       text: AppLocalizations.of(context)!.onBoarding_introPageFour_icon_text_Three
                   ),
                   SizedBox(height: widgetBottomPadding)
                 ],),
               )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
