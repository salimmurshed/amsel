import 'package:flutter/material.dart';

import '../../imports/common.dart';

Widget buildCalendarTheme(BuildContext context, Widget? child) {
  return Theme(
    data: Theme.of(context).copyWith(
      // hoverColor: ColorManager.primaryDark,
      colorScheme: ColorScheme.light(
        primary: AppColor.colorPrimary,
        onPrimary: AppColor.colorTextDarkBG,
        onSurface: AppColor.colorTextLightBG,
        surface: AppColor.colorPrimary,

      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.colorPrimary,
        ),
      ),
    ),
    child: child!,
  );
}