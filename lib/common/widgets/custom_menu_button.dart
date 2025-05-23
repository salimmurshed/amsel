import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../imports/common.dart';

GestureDetector buildMenuButton(BuildContext context,
    {required dynamic argument,
      required String routName,
      required String menuTitle,
      required bool hasPrefix,
      required String iconUrl}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routName, arguments: argument);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColor.colorTextLightBG,
      ),
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      margin: EdgeInsets.only(bottom: widgetBottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(hasPrefix)
            Container(
              padding: EdgeInsets.only(top:5.h),
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: AppColor.colorPrimary.withOpacity(0.1),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconUrl,
                  height: 20.h,
                  width: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  menuTitle,
                  style: Style.descTextStyle(
                    color: AppColor.colorPrimary,
                  ),
                ),
                const Spacer(), // Adds a flexible space to push the arrow to the right
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.colorPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}