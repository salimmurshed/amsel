import 'package:flutter/material.dart';

import '../../imports/common.dart';



class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({super.key, required this.isChecked, this.isLink = false,
    this.isCenter= false, this.text, required this.onChanged});

  final bool isChecked, isLink, isCenter;
  final String? text;
  final Function(bool?)? onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //if you want to set text and check box center align set isCenter = true while use this widget
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        Checkbox(
          side: BorderSide(color: AppColor.colorPrimary),
          value: widget.isChecked,
          onChanged: widget.onChanged,
          activeColor: AppColor.colorPrimary,
          checkColor: AppColor.colorTextLightBG,
          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //Above two lines added to remove default internal padding of radio widget
        ),
        const SizedBox(width: 5),
            Expanded(
              child: Text(
                  widget.text!,
                  style: Style.subTitleStyle(),
                ),
            ),
      ],
    );
  }
}