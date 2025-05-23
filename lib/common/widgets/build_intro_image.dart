import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';
import '../../main.dart';

buildIntroImage() => ImageView(
      imagePath: Assets.imgIntroBG,
      width: double.infinity,
      height:
           MediaQuery.of(navigatorKey.currentContext!).size.height * 0.4,
    );
