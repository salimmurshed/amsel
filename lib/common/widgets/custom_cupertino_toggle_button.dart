import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';

class CustomCupertinoToggleButton extends StatefulWidget {
  const CustomCupertinoToggleButton(
      {super.key,
        required this.trackColor,
        required this.onChanged,
        required this.isToggled});
  final Color trackColor;
  final Function(bool) onChanged;
  final bool isToggled;

  @override
  State<CustomCupertinoToggleButton> createState() => _CustomCupertinoToggleButtonState();
}

class _CustomCupertinoToggleButtonState extends State<CustomCupertinoToggleButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      trackColor: widget.trackColor,
      activeColor: AppColor.colorPrimary,
      thumbColor: AppColor.colorWhite,
      onChanged: widget.onChanged,
      value: widget.isToggled,
    );
  }
}