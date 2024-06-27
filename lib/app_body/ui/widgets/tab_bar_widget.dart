import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/app_daimentions.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: AppDimensions.radiusLarge(radius: 30),
          color: Colors.green.shade400),
      child: const TabBar(
        dividerColor: Colors.transparent,
        indicator: null,
        tabs: [
          Tab(text: 'Unassigned'),
          Tab(text: 'Assigned'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }
}
