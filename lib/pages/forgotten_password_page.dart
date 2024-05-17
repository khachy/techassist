// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/components/custom_textfield.dart';

class ForgottenPasswordPage extends StatefulWidget {
  const ForgottenPasswordPage({super.key});

  @override
  State<ForgottenPasswordPage> createState() => _ForgottenPasswordPageState();
}

class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  // formkey
  final formKey = GlobalKey<FormState>();
  // email controller
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // login user
  Future<void> loginUser() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      // final user = FirebaseAuth.instance.currentUser;
      setState(() {
        isLoading = true;
      });

      if (isLoading) {
        try {
          //  authenticate and create user
          await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim(),
          );
          await Future.delayed(const Duration(seconds: 5));

          final snackBar = SnackBar(
            content:
                const Text('A verification link has been sent to your email!'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            isLoading = false;
          });

          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          setState(() {
            isLoading = false;
          });
          final snackBar = SnackBar(
            content: Text(e.message.toString()),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      await Future.delayed(const Duration(seconds: 5));
    } else {
      return;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            // image
            SvgPicture.asset(
              'assets/forgot_password.svg',
              height: 130.h,
            ),
            SizedBox(
              height: 40.h,
            ),
            // forgot password text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.r),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forgot',
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Password?',
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // don't worry text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Don\'t worry! it happens. Please enter the email address associated with your account.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Form(
                key: formKey,
                child: CustomTextField(
                  controller: emailController,
                  icon: Icons.alternate_email_rounded,
                  title: 'Email Address',
                  hintText: 'e.g abc123@gmail.com',
                  obscureText: false,
                  maxLength: 50,
                  validator: (email) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[a-z])(?=.*?[@])(?=.*?[a-z])(?=.*?[.])');
                    if (email != null && !regex.hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomButton(
                onPressed: isLoading ? null : loginUser,
                child: isLoading
                    ? Center(
                        child: Transform.scale(
                          scale: 0.8,
                          child: const CircularProgressIndicator(
                            color: AppColors.deepPurple,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : Text(
                        'Continue',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18.sp,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
