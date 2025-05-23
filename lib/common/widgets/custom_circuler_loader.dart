import 'package:flutter/material.dart';

import '../../imports/common.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
          color: AppColor.colorPrimary,
        )
    );
  }
}
