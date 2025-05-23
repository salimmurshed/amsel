import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

class FocusListItemView extends StatelessWidget {
  const FocusListItemView({super.key, this.isSelected = false,
    required this.index, required this.length, required this.title,
    required this.subTitle, required this.iconData});

  final bool? isSelected;
  final String title, subTitle;
  final String iconData;
  final int index, length;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.containerShadowDecoration(radius: containerRadius, color: isSelected! ? AppColor.colorPrimary : AppColor.colorWhite),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: menuCardHorizontalPadding, vertical: menuCardVerticalPadding),
        child: Column(
          children: [
            ImageView(svgPath: iconData, width: 20.w, height: 18.h, color: isSelected! ? AppColor.colorWhite : AppColor.colorPrimary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
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
