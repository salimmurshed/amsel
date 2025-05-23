import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../../../main.dart';

Container buildMenu(
    {dynamic argument, String routeName = '',
    required String menuTitle, String link = "",
    required String iconUrl,
    bool isBrowser = false,
    bool isContact = false,
    required BuildContext context}) {
  return Container(
    padding: EdgeInsets.fromLTRB(menuCardHorizontalPadding, 0, 0, 0),
    child: GestureDetector(
      onTap: () async {
        if (link.isEmpty) {
          Navigator.pushNamed(context, routeName, arguments: argument);
        } else {
          openBrowserFromUrl(url: link);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
              svgPath: iconUrl,
              width: 18.w,
              height: isTablet? 30.h:16.h,
              color: AppColor.colorTextLight),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 14.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: AppColor.colorSecondaryText,
                    width: 0.6,
                  ),
                )),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        menuTitle,
                        style: Style.descTextStyle(),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ImageView(
                        svgPath:
                            isBrowser ? Assets.icShare : Assets.icRightArrow,
                        width: isBrowser ? 16.w : 12.w,
                        height: isTablet? 30.h:isBrowser ? 14.h : 10.h,
                        color: AppColor.colorSecondaryText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
