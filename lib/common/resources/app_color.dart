import 'package:flutter/material.dart';

class AppColor {
  static Color colorPrimary = HexColor.fromHex("#45D0FF");
  static Color colorPrimaryBG = HexColor.fromHex("#75DCFF").withOpacity(0.5);
  static Color colorBlack = HexColor.fromHex("#000000");
  static Color colorTextLight = HexColor.fromHex("#343434");
  static Color colorTextLightBG = HexColor.fromHex("#343434");
  static Color colorTextDarkBG = HexColor.fromHex("#FFFFFF");
  static Color colorWhite = HexColor.fromHex("#FFFFFF");
  static Color colorVeryLightGrey = HexColor.fromHex("#FAFAFA");
  static Color colorLightGrey = HexColor.fromHex("#EDEDED");
  static Color colorSecondaryText = HexColor.fromHex("#A2A2A2");

  static Color colorSecondText = HexColor.fromHex("#FAFAFA");
  static Color colorAlert = HexColor.fromHex("#FF2B2B");
  static Color colorAccent = HexColor.fromHex("#2E90FA");
  static Color colorDisable = HexColor.fromHex("#D0D5DD");
  static Color colorWarning = HexColor.fromHex('#F79009');
  static Color colorSuccess = HexColor.fromHex('#00C853');
  static Color colorSecondary = HexColor.fromHex("#475467");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
