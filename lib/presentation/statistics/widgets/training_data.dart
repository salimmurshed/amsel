import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

Container headerData({required String title, required String value, bool isFirst = false, String desc = ""}) {
  return Container(
    decoration: Style.containerShadowDecoration(radius: containerRadius),
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: 4.h,
          horizontal: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$title\n",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Style.paragraphStyle(fontSize: 11.sp)),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(value,
                style: Style.subHeaderStyle(color: AppColor.colorPrimary)),
          ),

          Text(isFirst ? desc : "",
              textAlign: TextAlign.center,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: Style.infoTextBoldStyle(
                  textDecoration: TextDecoration.underline))
        ],
      ),
    ),
  );
}
