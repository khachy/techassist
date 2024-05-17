import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/pages/login_signup_page.dart';
import 'package:techassist_app/verify_email.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // initialize the loading circle
  bool isLoading = false;
  // naviagte to auth page
  void navigateToLoginOrSignUpPage() async {
    setState(() {
      isLoading = true;
    });
    // set the loading circle timer
    await Future.delayed(const Duration(seconds: 5));
    // navigate to auth page
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
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
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginOrSignUpPage();
          },
        ));

    // change the loading circle status
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userHasAccount = snapshot.data;

            if (userHasAccount!) {
              // User has an account, navigate to the verify page to check if the user's email is verified
              return const VerifyEmail();
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.whiteColor,
                  elevation: 0,
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        // onboarding image
                        SvgPicture.asset(
                          'assets/team.svg',
                          height: 200.h,
                        ),
                        SizedBox(height: 50.h),
                        // welcome text
                        Text(
                          'Welcome to TechAssist!',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // welcome message
                        Text(
                          'Your go-to solution for a seamless IT support and system management.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.grey700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 50.h),
                        CustomButton(
                          onPressed:
                              isLoading ? null : navigateToLoginOrSignUpPage,
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
                                  'Let\'s go',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.whiteColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.deepPurple,
                ),
              ),
            );
          }
        });
  }

  Future<bool> _checkUserStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // User is signed in, check Firestore for additional info
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc.exists; // Return true if the user has an account
    } else {
      // User is not signed in
      return false;
    }
  }
}
