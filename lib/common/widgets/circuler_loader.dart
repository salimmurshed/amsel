import 'package:flutter/material.dart';

import '../../imports/common.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
          color: AppColor.colorPrimary,
        )
    );
  }
}
