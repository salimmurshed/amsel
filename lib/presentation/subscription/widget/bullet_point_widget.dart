import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

Row bulletPointText({required String text}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("\u2022", style: Style.descTextStyle()),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(text, style: Style.descTextStyle()),
        ),
      ),
    ],
  );
}