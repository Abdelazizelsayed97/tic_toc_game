import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDimensions {
 static EdgeInsets large() {
    return EdgeInsets.all(16.r);
  }

 static EdgeInsets xLarge() {
    return EdgeInsets.all(20.r);
  }

 static EdgeInsets small() {
    return EdgeInsets.all(8.r);
  }

 static  EdgeInsets meduim() {
    return EdgeInsets.all(12.r);
  }
  static  BorderRadiusGeometry? radiusMeduim({double? radius}) {
    return BorderRadius.circular(radius??12.r);
  }
  static  BorderRadiusGeometry? radiusLarge({double? radius}) {
    return BorderRadius.circular(radius??16.r);
  }
  static  BorderRadiusGeometry? radiusSmall({double? radius}) {
    return BorderRadius.circular(radius??8.r);
  }

}
