import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';
import 'custom_text_field.dart';

class RowWithTwoTextFields extends StatelessWidget {
  const RowWithTwoTextFields(
      {super.key,
        this.leftFieldFocusNode,
        this.rightTextFieldFocusNode,
        this.isLeftFieldHasError,
        this.isRightTextFieldHasError,
        required this.leftTextFieldEditController,
        required this.rightTextFieldEditController,
        this.leftTextFieldHintText,
        this.rightTextFieldHintText,
        this.leftTextFieldVariant,
        this.rightTextFieldVariant,
        this.leftTextFieldValidator,
        this.rightTextFieldValidator,
        this.onTapLeft,
        this.onTapRight,
        this.leftLabel = '',
        this.rightLabel = ''});

  final FocusNode? leftFieldFocusNode, rightTextFieldFocusNode;
  final bool? isLeftFieldHasError, isRightTextFieldHasError;
  final TextEditingController leftTextFieldEditController,
      rightTextFieldEditController;
  final String? leftTextFieldHintText, rightTextFieldHintText;
  final TextFieldVariant? leftTextFieldVariant, rightTextFieldVariant;
  final FormFieldValidator<String>? leftTextFieldValidator,
      rightTextFieldValidator;
  final String leftLabel, rightLabel;
  final Function()? onTapLeft;
  final Function()? onTapRight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
              label: leftLabel,
              focusNode: leftFieldFocusNode,
              controller: leftTextFieldEditController,
              hintText: leftTextFieldHintText,
              variant: leftTextFieldVariant,
              onTap: onTapLeft,
              validator: leftTextFieldValidator),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomTextField(
              label: rightLabel,
              focusNode: rightTextFieldFocusNode,
              controller: rightTextFieldEditController,
              hintText: rightTextFieldHintText,
              variant: rightTextFieldVariant,
              onTap: onTapRight,
              validator: rightTextFieldValidator),
        ),
      ],
    );
  }
}
