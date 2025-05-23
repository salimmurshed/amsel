import 'package:flutter/material.dart';
import '../../imports/common.dart';

Widget customCardWithToggleButton(
    {required String title,
      required Function() toggle,
      required bool isToggled,
    }) =>
    Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Style.titleSemiBoldStyle()),
                CustomCupertinoToggleButton(
                  trackColor: AppColor.colorAlert,
                  onChanged: (value) {
                    toggle();
                  },
                  isToggled: isToggled,
                ),
              ],
            ),
          ],
        ),
      ),
    );