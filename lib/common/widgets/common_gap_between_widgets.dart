import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGapBetweenWidgets extends StatelessWidget {
  const CommonGapBetweenWidgets({super.key, this.child, this.isTop});

  final Widget? child;
  final bool? isTop;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: isTop == null? EdgeInsets.only(bottom: 20.h,) : EdgeInsets.only(top: 20.h,),
      child: child,
    );
  }
}
