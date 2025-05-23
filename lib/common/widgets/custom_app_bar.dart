import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../imports/common.dart';
import '../../main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.isLeading = true,
    this.onTap,
  });

  final Widget? leading;
  final bool isLeading;
  final String? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: Style.containerShadowDecoration(isAppBar: true),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColor.colorWhite,
            leading: isLeading
                ? AppBarActionIcon(
                    isLeading: isLeading,
                    svg: Assets.icLeftArrow,
                iconH: isTablet ? 40.h: 15.h, iconW: isTablet ? 40.w:15.w,
                    onTap: onTap ??
                        () {
                          Navigator.pop(context);
                        })
                : null,
            title: Container(
                padding: isLeading == false
                    ? EdgeInsets.only(left: screenHPadding)
                    : EdgeInsets.zero,
                child: Text(
                  title!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style:
                      Style.appBarTitleStyle(color: AppColor.colorTextLightBG),
                )),
            titleSpacing: 0,
            toolbarHeight: isTablet? 60.h:AppBar().preferredSize.height,
            centerTitle: centerTitle ?? false,
            actions: actions,
            // systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        )
    );
  }

  @override
  Size get preferredSize => isTablet? Size.fromHeight(60.h):
      Size.fromHeight(AppBar().preferredSize.height);
}
