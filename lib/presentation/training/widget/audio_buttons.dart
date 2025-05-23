import 'package:amsel_flutter/common/resources/app_color.dart';
import 'package:amsel_flutter/common/widgets/image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget audioButton({required String svgPath, required Function() onTap, Color? color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      child: ImageView(svgPath: svgPath, color: color?? AppColor.colorTextLightBG),
    ),
  );
}