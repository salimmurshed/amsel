import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../../../main.dart';

GestureDetector bottomBarItem(
    {required bool isSelected,
    required String text,
    required String svgPath,
    required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: AppColor.colorVeryLightGrey,
        // color: Colors.pink,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageView(
              svgPath: svgPath,
            height: isTablet?20.h:null,
            width: isTablet?20.w:null,
              color: isSelected
                  ? AppColor.colorPrimary
                  : AppColor.colorTextLightBG,

          ),
          Padding(
            padding: EdgeInsets.only(top: bottomBarItemSpaceInBetween),
            child: Text(text,
                style: Style.navBarTitleStyle(isSelected: isSelected)),
          )
        ],
      ),
    ),
  );
}
