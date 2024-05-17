import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:techassist_app/components/colors.dart';
// import 'package:techassist_app/models/status.dart';

class StatusTile extends StatelessWidget {
  const StatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      width: 65.w,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: Colors.yellow.shade800,
        ),
      ),
      child: Center(
        child: Text('OPEN', style: TextStyle(
          color: Colors.yellow.shade800,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
    );
  }
}