// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/pages/home_page.dart';
import 'package:techassist_app/pages/login_signup_page.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  // check whether a user can resend email
  bool canResendEmail = false;
  Timer? timer;
  // regitered user
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    // user needs to be created before
    isEmailVerified = user.emailVerified;

    // send a verification email if the user's email is not yet verified
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 5), (_) => checkEmailVerified());
    }
  }

  Future checkEmailVerified() async {
    // call after email verification
    await FirebaseAuth.instance.currentUser!.reload();
    if (mounted) {
      setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    }

    if (isEmailVerified) {
      return timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  // send the verification email
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
               final snackBar = SnackBar(
          content: const Text('A verification instruction has been sent to your email!'), 
          behavior: SnackBarBehavior.floating, 
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h,),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        canResendEmail = true;
      });
    } on FirebaseAuthException catch (e) {
       final snackBar = SnackBar(
          content: Text(e.message.toString()), 
          behavior: SnackBarBehavior.floating, 
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h,),
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

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h
                ),
                // illustrator
                SvgPicture.asset('assets/mail_sent.svg', height: 100.h,),
                 SizedBox(
                  height: 35.h
                ),
                // check your email text
                Text('Check your Inbox!', style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),),
                 SizedBox(
                  height: 25.h
                ),
                // we sent a verification text
                Column(
                  children: [
                    Text('We have sent a verifcation instruction to', style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey700,
                    ),
                    textAlign: TextAlign.center,
                    ),
                    Text('${user.email}', style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
                SizedBox(
                  height: 60.h,
                ),
                // button
                CustomButton(
                  onPressed: canResendEmail ? sendVerificationEmail : null, 
                  child: !canResendEmail
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
                        'Resend',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 18.sp,
                          letterSpacing: 1,
                          
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                  SizedBox(
                    height: 30.h
                  ),
                  // try another email address
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const LoginOrSignUpPage();
                          }),
                    ),
                    child: const Text('Or try another email address?', style: TextStyle(
                      color: AppColors.deepPurple,
                    ),),
                  ),
              ],
            ),
          ),
        ),
      );
}
