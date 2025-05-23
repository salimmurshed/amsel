import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

class ListItemCardView extends StatelessWidget {
  const ListItemCardView({super.key, this.isSelected = false,
    required this.title, required this.subTitle, required this.iconData});

  final bool? isSelected;
  final String title, subTitle;
  final String iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.containerShadowDecoration(radius: containerRadius, color: isSelected! ? AppColor.colorPrimary : AppColor.colorWhite),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: menuCardHorizontalPadding, vertical: menuCardVerticalPadding),
        child: Column(
          children: [
            iconData.contains("png") ? ImageView(imagePath: iconData, height: 24.h, width: 24.w, color: isSelected! ? AppColor.colorWhite : AppColor.colorPrimary) :
            ImageView(svgPath: iconData, height: 24.h, width: 24.w, color: isSelected! ? AppColor.colorWhite : AppColor.colorPrimary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(title, textAlign: TextAlign.center, style: Style.descTextBoldStyle(
                  height: 1.h,
                  color: isSelected! ? AppColor.colorWhite : AppColor.colorTextLightBG)),
            ),
            Text(subTitle, textAlign: TextAlign.center,
                style: Style.descTextStyle(height: 1.h,
                color: isSelected! ? AppColor.colorWhite : AppColor.colorTextLightBG))
          ],
        ),
      ),
    );
  }
}