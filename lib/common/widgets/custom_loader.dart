import 'package:flutter/material.dart';

import '../../imports/common.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key, required this.child, this.height, this.width});
  final Widget child;
  final double? height, width;

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationController!.repeat();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: animationController!.drive(ColorTween(
                    begin: AppColor.colorWarning,
                    end: AppColor.colorAccent
                )), //AlwaysStoppedAnimation(AppColor.secondaryBlue),
                color:Colors.transparent,
              ),
              // WidthSpacer(myWidth: 25.50),
              // Text(AppKeywords.loading),
            ],
          ),
        ),
      ],
    );
  }
}