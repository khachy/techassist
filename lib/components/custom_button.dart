import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const CustomButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
