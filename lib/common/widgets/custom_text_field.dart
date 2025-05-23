import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../imports/common.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixText,
    this.errorText,
    this.isReadOnly = false,
    this.focusNode,
    this.validator,
    this.inputFormatters,
    this.autofocus = false,
    this.onFieldSubmit,
    this.isAuth = false,
    this.onChanged,
    this.nextFocusNode,
    this.onTap,
    this.isObscureText,
    this.variant,
    this.filledColor,
    this.autoValidate = false,
    this.errorTextLength = 2,
    this.onTapPassword,
    this.isDone = false,
    this.label = '',
    this.textInputType = TextInputType.text,
    this.maxLine = 1,
  });

  final bool isAuth;
  final bool autoValidate;
  final bool isReadOnly;
  final TextEditingController controller;
  final String? hintText, prefixText;
  final String? errorText;
  final FocusNode? focusNode, nextFocusNode;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool? isObscureText;
  final Function(void)? onFieldSubmit;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  final TextFieldVariant? variant;
  final Color? filledColor;
  final int errorTextLength, maxLine;
  final Function()? onTapPassword;
  final bool isDone;
  final String label;
  final TextInputType textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.label,
                  style: Style.infoTextBoldStyle()),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus!,
          textAlign: TextAlign.start,
          keyboardType: widget.variant != null
              ? setTextInputType(variant: widget.variant)
              : widget.textInputType,
          textAlignVertical: TextAlignVertical.center,
          enabled: true,
          style: Style.textFieldInputStyle(),
          inputFormatters:
              widget.inputFormatters ?? setInputFormatter(variant: widget.variant),
          readOnly: widget.isReadOnly,
          textInputAction:
              widget.isDone ? TextInputAction.done : TextInputAction.next,
          maxLines: widget.maxLine,
          cursorColor: AppColor.colorPrimary,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            hintText: widget.hintText ?? "",
            hintStyle: Style.hintStyle(),
            fillColor: AppColor.colorWhite,
            errorMaxLines: widget.errorTextLength,
            errorStyle: Style.errorStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(iconContainerRadius),
              borderSide: BorderSide(width: 1, color: AppColor.colorSecondaryText),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(iconContainerRadius),
              borderSide: BorderSide(width: 1, color: AppColor.colorSecondaryText),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(iconContainerRadius),
              borderSide: BorderSide(width: 1, color: AppColor.colorSecondaryText),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(iconContainerRadius),
              borderSide: BorderSide(width: 1, color: AppColor.colorSecondaryText),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(iconContainerRadius),
              borderSide: BorderSide(width: 1, color: AppColor.colorSecondaryText),
            ),
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmit,
        ),
      ],
    );
  }

  setInputFormatter({TextFieldVariant? variant}) {
    switch (variant) {
      case TextFieldVariant.name:
        return [LengthLimitingTextInputFormatter(36)];
      case TextFieldVariant.fav:
        return [LengthLimitingTextInputFormatter(50)];
      default:
        return null;
    }
  }

  setTextInputType({TextFieldVariant? variant}) {
    switch (variant) {
      case TextFieldVariant.email:
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}
