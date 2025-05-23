import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../imports/common.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.variant,
    this.buttonSize,
    this.alignment,
    this.margin,
    this.onTap,
    this.width,
    this.height,
    required this.text,
    this.faint,
    this.prefixWidget,
    this.suffixWidget,
    this.padding
  });

  final ButtonVariant? variant;
  final ButtonSize? buttonSize;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? width, height;
  final String text;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final int? faint;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: buildButtonWidget(),
    )
        : buildButtonWidget();
  }

  buildButtonWidget() {
    // return ElevatedButton(
    //     onPressed: onTap,
    //     style: buildTextButtonStyle(),
    //     child: Text(text,
    //         textAlign: TextAlign.center, style: Style.buttonLabel(
    //             buttonSize: buttonSize ?? ButtonSize.large,
    //             color: getTextColor()
    //         ))
    // );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? setButtonSize(),
        width: width,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: getBackgroundColor(),
          border: Border.all(
            color: getBorderColor(),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          // color: Colors.purple,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Style.buttonLabel(color: getTextColor()),
          ),
        ),
      ),
    );
  }

  // buildTextButtonStyle() {
  //   return TextButton.styleFrom(
  //       fixedSize: Size(
  //         // if you don't set width it will take max width else you can set width according to your design
  //           width ?? double.maxFinite,
  //           height ?? setButtonSize()
  //       ),
  //       alignment: Alignment.center,
  //       elevation: 0,
  //       backgroundColor: getBackgroundColor(),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(cardRadius),
  //           side: BorderSide(
  //               color: getBorderColor(),
  //               width: 1,
  //               style: BorderStyle.solid)
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 10)
  //   );
  // }

  //use AppColor to set Background Colors here
  getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.btnPrimary:
        return AppColor.colorPrimary;
      case ButtonVariant.btnDisable:
        return AppColor.colorDisable;
      case ButtonVariant.btnWithBorder:
        return AppColor.colorDisable;
      default:
        return AppColor.colorAccent;
    }
  }

  //use AppColor to set Border Colors here
  getBorderColor() {
    switch (variant) {
      case ButtonVariant.btnPrimary:
        return AppColor.colorPrimary;
      case ButtonVariant.btnDisable:
        return AppColor.colorDisable;
        case ButtonVariant.btnWithBorder:
        return AppColor.colorPrimary;
      default:
        return AppColor.colorAccent;
    }
  }

  //use AppColor to set Text Colors here
  getTextColor() {
    switch (variant) {
      case ButtonVariant.btnDisable:
        return AppColor.colorTextDarkBG;
      case ButtonVariant.btnPrimary:
        return AppColor.colorTextDarkBG;
      case ButtonVariant.btnWithBorder:
        return AppColor.colorTextLightBG;
      default:
        return AppColor.colorTextDarkBG;
    }
  }

  setButtonSize() {
    switch (buttonSize) {
      case ButtonSize.large:
        return largeButtonHeight;
      default:
        return mediumButtonHeight;
    }
  }
}