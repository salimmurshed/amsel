import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../imports/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/widgets/build_intro_image.dart';

class IntroPageFive extends StatelessWidget {
  const IntroPageFive({super.key, });

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
                      Text(AppLocalizations.of(context)!.onBoarding_introPageFive_title_partOne,
                          textAlign: TextAlign.center, style: Style.pageHeaderStyle()),
                      Text(AppLocalizations.of(context)!
                          .onBoarding_introPageFive_title_partTwo ,
                        style: Style.pageHeaderStyle(
                            colorBG: AppColor.colorPrimaryBG),
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.onBoarding_introPageFive_subtitle_partOne,
                              style: Style.descTextStyle(),
                            ),
                            TextSpan(
                                text: AppLocalizations.of(context)!.onBoarding_introPageFive_subtitle_partTwo,
                                style: Style.descTextBoldStyle()),
                            TextSpan(
                              text: AppLocalizations.of(context)!.onBoarding_introPageFive_subtitle_partThree,
                              style: Style.descTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: widgetBottomPadding),
                      // Text(AppLocalizations.of(context)!.onBoarding_introPageFive_infoOne,
                      //   textAlign: TextAlign.center,
                      //   style: Style.descTextStyle(),
                      // ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoOne_partOne,
                              style: Style.descTextStyle(),
                            ),
                            TextSpan(
                                text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoOne_partTwo,
                                style: Style.descTextBoldStyle()),
                            TextSpan(
                              text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoOne_partThree,
                              style: Style.descTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: widgetBottomPadding),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoTwo_partOne,
                                style: Style.descTextStyle(),
                              ),
                              TextSpan(
                                  text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoTwo_partTwo,
                                  style: Style.descTextBoldStyle()),
                              TextSpan(
                                text: AppLocalizations.of(context)!.onBoarding_introPageFive_infoTwo_partThree,
                                style: Style.descTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: widgetBottomPadding),
                        child: Text(AppLocalizations.of(context)!.onBoarding_introPageFive_infoThree,
                            textAlign: TextAlign.center, style: Style.descTextStyle()),
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
