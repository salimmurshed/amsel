import 'package:amsel_flutter/common/dimensions/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';
import '../../main.dart';

class AppBarActionIcon extends StatelessWidget {
  final bool isLeading;
  final String svg;
  final EdgeInsets? margin;
  final Function()? onTap;
  final double? height, width;
  final double? iconH, iconW;

  const AppBarActionIcon(
      {super.key,
      required this.isLeading,
      this.margin,
      required this.svg,
      required this.onTap,
      this.height,
      this.width,
      this.iconH,
      this.iconW});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isTablet? EdgeInsets.symmetric(horizontal: 5.w, ): null,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(cardRadius)),
        alignment: Alignment.center,
        child: ImageView(
          svgPath: svg,
          fit: BoxFit.contain,
          height: iconH,
          width: iconW,
        ),
      ),
    );
  }
}
