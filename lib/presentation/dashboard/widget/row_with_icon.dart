import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';
import '../../../main.dart';

Row rowWithIconText({required String text, required String imagePath}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      imagePath.contains("png") ? ImageView(
          imagePath: imagePath,  height: isTablet?20.h:15.h, width: 15.w, color: AppColor.colorPrimary) : ImageView(
          svgPath: imagePath,  height: isTablet?20.h:15.h, width: 15.w, color: AppColor.colorPrimary),
      SizedBox(width: 10.w),
      Expanded(
        child: Text(text, style: Style.descTextStyle()),
      ),
    ],
  );
}

Row rowWithDoubleIconText({required String leftText, rightText, leftImagePath, rightImagePath}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          child: rowWithIconText(text: leftText, imagePath: leftImagePath)
      ),
      Expanded(
          child: rowWithIconText(text: rightText, imagePath: rightImagePath)
      ),
    ],
  );
}
