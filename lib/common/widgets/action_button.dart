import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';
import '../../main.dart';

InkWell actionButtonIcon(
    {required Color color,
    required String svgPath,
    required Function() onPressed,
    bool isInfo = false}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      height:isTablet? 60.h: (isInfo ? 40.h : 32.h),
      width: isInfo ? 40.w : 32.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ImageView(svgPath: svgPath,
      height: isTablet?20.h:null,
      width: isTablet?20.w:null,
),
    ),
  );
}
