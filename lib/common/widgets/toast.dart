import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/svg.dart';
import '../../imports/common.dart';

class Toast{
   static nullableIconToast({required String message,  String? icon, required bool? isErrorBooleanOrNull, Alignment alignment= Alignment.topCenter} ){
     BotToast.showCustomNotification(
       duration: Duration(seconds: toastDurationInSeconds),
        enableSlideOff: true,
       align: alignment,
       toastBuilder: (cancelFunc) {
         return Padding(
           padding: EdgeInsets.symmetric(horizontal: 18.w),
           child: Card(
             elevation: cardElevation,
             color: isErrorBooleanOrNull == null ? getToastBackgroundColor(toastState: ToastState.info): isErrorBooleanOrNull ? getToastBackgroundColor(toastState: ToastState.fail) : getToastBackgroundColor(toastState: ToastState.success),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(toastBorderRadius),
             ),
             child: ListTile(
               contentPadding:
                EdgeInsets.symmetric(horizontal: containerHorizontalPadding, vertical: 2.h),
               title: Row(
                 crossAxisAlignment: icon != null? CrossAxisAlignment.start : CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   if(icon != null)
                   SvgPicture.asset(icon, height: 30.h, width:30.w),
                   SizedBox(width: 10.w),
                   Flexible(
                     child: Text(message,
                         maxLines: toastMaxLines,
                         style: Style.subTitleStyle(color: AppColor.colorTextDarkBG)),
                   )
                 ],
               ),
             ),
           ),
         );
       },
     );
   }

   static Color getToastBackgroundColor({required ToastState toastState}){
     switch (toastState) {
       case ToastState.success:
         return AppColor.colorSuccess;
       case ToastState.fail:
         return AppColor.colorAlert;
       case ToastState.info:
         return AppColor.colorWarning;
       default:
         return AppColor.colorSecondary;
     }
   }
}
