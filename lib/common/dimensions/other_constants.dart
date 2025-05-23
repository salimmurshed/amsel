import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


//Duration in seconds
int toastDurationInSeconds = 4;
double cardElevation = 3.h;
//MaxLines
int toastMaxLines = 3;
getScreenHeight({required BuildContext context}){
  return MediaQuery.of(context).size.height;
}
getScreenWidth({required BuildContext context}){
  return MediaQuery.of(context).size.height;
}


