import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

Container iconTextWidget({String? svgPath, String? imagePath, required String text, bool isArrow = false, bool isOnlyOne = false}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: isOnlyOne ? 30.w : 8.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(iconContainerRadius),
      color: AppColor.colorVeryLightGrey,
      border: Border(
        bottom: BorderSide(color: AppColor.colorPrimary, width: 1)
      )
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isArrow ? 8.h : 0),
          child: ImageView(svgPath: svgPath, imagePath: imagePath, height: isArrow ? 24.h : 48.h, width: isArrow ? 24.w : 48.w,  fit: BoxFit.contain),
        ),
        Text(text, style: Style.infoTextStyle())
      ],
    ),
  );
}