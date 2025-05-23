import 'package:amsel_flutter/imports/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SliderTheme sliderTheme({required BuildContext context, required Slider slider, required bool isForDuration}) {
  return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColor.colorPrimary,
        inactiveTrackColor: AppColor.colorLightGrey,
        trackHeight: isForDuration ? 16.h : 10.h,
        thumbShape: CustomThumbShape(radius: isForDuration ? 18.r : 10.r),
        thumbColor: AppColor.colorPrimary,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
      ),
      child: slider);
}

class CustomThumbShape extends RoundSliderThumbShape {
  final double radius;

  CustomThumbShape({required this.radius});

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        double? textScaleFactor,
        Size? sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Draw shadow
    final Path shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.25), 4.0, true);

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint fillPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, paint);
  }
}