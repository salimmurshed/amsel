import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.btnText,
    this.isDone = false,
    this.isOk = false,
    this.onTapEndButton,
    this.onTapButton,
    this.onTapOkButton,

  });

  final String title;
  final String subTitle;
  final String btnText;
  final bool isDone;
  final bool isOk;
  final Function()? onTapEndButton;
  // final Function()? onTapRepeatButton;
  final Function()? onTapOkButton;
  final Function()? onTapButton;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.colorLightGrey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(title, textAlign: TextAlign.center, style: Style.headerStyle())),
            SizedBox(height: 15.h),
            Text(subTitle, style: Style.descTextStyle()),
            SizedBox(height: 15.h),
            isOk ? CustomButton(
                variant: ButtonVariant
                    .btnPrimary,
                buttonSize:
                ButtonSize.medium,
                text: btnText,
                onTap: onTapOkButton)
                : Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: onTapEndButton ?? () {Navigator.pop(context);},
                      child: Text(isDone ? AppLocalizations.of(context)!
                              .training_end_challenge_btn : AppLocalizations.of(context)!.training_addToFav_dialog_cancelBtn,
                          style: Style.buttonLabel(
                              color: AppColor.colorTextLightBG))),
                ),
                Expanded(
                  child: CustomButton(
                    height: 40.h,
                      variant: ButtonVariant
                          .btnPrimary,
                      buttonSize:
                      ButtonSize.medium,
                      text: btnText,
                      onTap: onTapButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}