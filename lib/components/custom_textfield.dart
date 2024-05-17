import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData icon;
  final IconData? suffixIcon;
  final String title;
  final bool obscureText;
  final void Function()? onPressed;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    required this.icon,
    required this.title,
    this.keyboardType,
    this.suffixIcon,
    required this.obscureText,
    this.onPressed,
    this.validator,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 9.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.deepPurple.shade100,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            filled: true,
            fillColor: AppColors.blue50,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey.shade500,
            ),
            suffixIcon: IconButton(
              icon: Icon(suffixIcon),
              color: Colors.black26,
              onPressed: onPressed,
            ),
          ),
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
