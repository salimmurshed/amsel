
import 'package:flutter/material.dart';

import '../../../common/resources/app_color.dart';
import '../../../common/resources/style.dart';

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center, style: Style.subTitleBoldStyle()),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: Style.descTextBoldStyle()),
              Slider(
                divisions: divisions,
                activeColor: AppColor.colorPrimary,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
                onChangeEnd: (value) => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}