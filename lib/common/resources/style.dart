import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';

// /**
//  Please note, you have to adhere to figma suggested font sizes, colors, and family.
//     This template has no font family added
//  */
class FontFamilies {
  static const String inter = "Inter";
}

class Style {
  // Bars
  static TextStyle appBarTitleStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.title,
      color: color ?? AppColor.colorPrimary,
    );
  }

  static TextStyle extraLargeTitleStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.titleLarge,
      color: color ?? AppColor.colorPrimary,
    );
  }

  static TextStyle navBarTitleStyle({required bool isSelected}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
      fontSize: AppFontSize.small,
      color: isSelected ? AppColor.colorPrimary : AppColor.colorTextLightBG,
    );
  }

  // Header, Sub-header, and body
  static TextStyle headerStyle({Color? color, Color? colorBG}) {
    return TextStyle(
      backgroundColor: colorBG ?? Colors.transparent,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.headerTitle,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle subHeaderStyle({Color? color, Color? colorBG}) {
    return TextStyle(
      backgroundColor: colorBG ?? Colors.transparent,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.subHeaderTitle,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle pageHeaderStyle({Color? color, Color? colorBG}) {
    return TextStyle(
      backgroundColor: colorBG ?? Colors.transparent,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.headerTitle,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle titleSemiBoldStyle({Color? color, Color? colorBG, double? hight}) {
    return TextStyle(
      backgroundColor: colorBG ?? Colors.transparent,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      height: hight ?? 1.5,
      fontSize: AppFontSize.pageTitle,
      color: color ?? AppColor.colorBlack,
    );
  }

  static TextStyle titleStyle({Color? color, Color? colorBG, double? height}) {
    return TextStyle(
      backgroundColor: colorBG ?? Colors.transparent,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      height: height ?? 0,
      fontSize: 28.sp,
      color: color ?? AppColor.colorBlack,
    );
  }

  static TextStyle descTextBoldStyle({Color? color, double? height, bool isRichSpan = false}) {
    return TextStyle(
      height: height ?? 0,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.regular,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle descTextStyle({Color? color, TextDecoration? textDecoration, double? height}) {
    return TextStyle(
      height: height ?? 0,
      decoration: textDecoration ?? TextDecoration.none,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.regular,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle infoTextStyle({Color? color,  TextDecoration? textDecoration}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w300,
      fontSize: AppFontSize.small,
      color: color ?? AppColor.colorTextLightBG,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }

  static TextStyle infoTextBoldStyle({Color? color, TextDecoration? textDecoration}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.small,
      decoration: textDecoration ?? TextDecoration.none,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle subTitleStyle({Color? color}) {
    return TextStyle(
        fontFamily: FontFamilies.inter,
        fontWeight: FontWeight.w400,
        fontSize: AppFontSize.subHeaderTitle,
        color: color ?? AppColor.colorTextLightBG,
        height: 1.5);
  }

  static TextStyle subTitleBoldStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.subHeaderTitle,
      height: 1.5,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle paragraphStyle({Color? color, double? fontSize}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? AppFontSize.normal,
      height: 1.5,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle smallStyle({Color? color, double? height}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontSize: AppFontSize.small,
      height: height ?? 1.5,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle smallWithoutHeightStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontSize: AppFontSize.small,
      height: 1.5,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle smallBoldStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.small,
      height: 1.5,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  static TextStyle paragraphBoldStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.normal,
      color: color ?? AppColor.colorTextLightBG,
    );
  }

  //Textfields
  static TextStyle hintStyle() {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.normal,
      color: AppColor.colorSecondaryText,
    );
  }

  static TextStyle errorStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.normal,
      color: color ?? AppColor.colorAlert,
    );
  }

  static TextStyle textFieldInputStyle() {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.normal,
      color: AppColor.colorTextLightBG,
    );
  }

  static TextStyle labelStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.regular,
      color: color ?? AppColor.colorPrimary,
    );
  }

  // buttonLabel
  static TextStyle buttonLabel({Color? color}) {
    return TextStyle(
      height: 0.7,
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w700,
      fontSize: AppFontSize.regular,
      color: color ?? AppColor.colorTextDarkBG,
    );
  }

  // static TextStyle textButtonStyle({Color? color}) {
  //   return TextStyle(
  //     fontFamily: FontFamilies.inter,
  //     fontWeight: FontWeight.w400,
  //     fontSize: AppFontSize.regular,
  //     color: color ?? AppColor.colorPrimary,
  //   );
  // }

  static TextStyle dropdownTitlesStyle({Color? color}) {
    return TextStyle(
      fontFamily: FontFamilies.inter,
      fontWeight: FontWeight.w400,
      fontSize: AppFontSize.normal,
      color: AppColor.colorPrimary,
    );
  }

  static TextStyle underlinedText({Color? color}) {
    return TextStyle(
        color: color ?? AppColor.colorTextDarkBG,
        decoration: TextDecoration.underline,
        fontSize: AppFontSize.normal);
  }

  static ShapeBorder bottomSheetShape() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(bottomSheetRadius),
            topRight: Radius.circular(bottomSheetRadius)));
  }

  static BoxDecoration commonBoxDecoration({Color? color}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        color: color ?? AppColor.colorPrimary);
  }

  static BoxDecoration containerShadowDecoration(
      {double? radius, Color? color , bool isAppBar = false}) {
    return BoxDecoration(
      color: color ?? AppColor.colorVeryLightGrey,
      borderRadius: BorderRadius.circular(radius ?? 0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: isAppBar ? 3 : 1,
          blurRadius: isAppBar ? 8: 15,
          offset: Offset(0, isAppBar ? 2: 5), // changes position of shadow
        ),
      ],
    );
  }

  static BoxDecoration bottomSheetDecoration({Color? color}) {
    return BoxDecoration(
      color: AppColor.colorWhite,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomSheetRadius),
          topRight: Radius.circular(bottomSheetRadius)),
      border: Border(
        top: BorderSide(
          color: color ?? AppColor.colorPrimary,
          width: 3,
        ),
      ),
    );
  }
}

