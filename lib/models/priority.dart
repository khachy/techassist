import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class Priority with ChangeNotifier {
  final List<List<dynamic>> _priority = [
    [
      Icon(
        Iconsax.arrow_circle_down,
        color: Colors.lightBlue,
        size: 13.sp,
      ),
      'Low',
      Colors.lightBlue,
      Colors.lightBlue.withOpacity(0.08),
      false
    ],
    [
      Icon(
        Iconsax.minus_cirlce,
        color: Colors.orange,
        size: 13.sp,
      ),
      'Medium',
      Colors.orange,
      Colors.orange.withOpacity(0.08),
      false
    ],
    [
      Icon(
        Iconsax.arrow_circle_up,
        color: Colors.red,
        size: 13.sp,
      ),
      'High',
      Colors.red,
      Colors.red.withOpacity(0.08),
      false
    ],
  ];

  List<List<dynamic>> get priority => _priority;
}
