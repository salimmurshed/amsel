import 'package:amsel_flutter/imports/common.dart';
import 'package:flutter/material.dart';
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.color});

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: color ?? AppColor.colorLightGrey);
  }
}
