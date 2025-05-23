import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

class DashboardItemCardView extends StatelessWidget {
  const DashboardItemCardView(
      {super.key,
      this.isSelected = false,
      required this.title,
      required this.subTitle,
      required this.iconData});

  final bool? isSelected;
  final String title, subTitle, iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.containerShadowDecoration(
          radius: containerRadius,
          isAppBar: true,
          color: isSelected! ? AppColor.colorPrimary : AppColor.colorWhite
          // color: Colors.purple
          ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10.w, vertical: cardVerticalPadding),
        child: Container(
          // color: Colors.pink,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center, style: Style.descTextStyle()),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 5.h),
                child: iconData.contains("png")
                    ? ImageView(
                        height: 24.h,
                        width: 24.w,
                        imagePath: iconData,
                        color: isSelected!
                            ? AppColor.colorWhite
                            : AppColor.colorPrimary)
                    : ImageView(
                        height: 24.h,
                        width: 24.w,
                        svgPath: iconData,
                        color: isSelected!
                            ? AppColor.colorWhite
                            : AppColor.colorPrimary),
              ),
              Text(subTitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Style.descTextBoldStyle())
            ],
          ),
        ),
      ),
    );
  }
}
