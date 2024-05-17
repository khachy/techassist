// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/components/custom_textfield.dart';
import 'package:techassist_app/pages/forgotten_password_page.dart';
import 'package:techassist_app/pages/register_page.dart';
import 'package:techassist_app/verify_email.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // formkey
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  // password visibility
  void passwordVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  // login user
  Future<void> loginUser() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      // authenticate the user
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await Future.delayed(
          const Duration(seconds: 5),
        );
        final snackBar = SnackBar(
          content: const Text('Login Successfully!'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppColors.green,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (mounted) {
          // change the loading status
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
                return const VerifyEmail();
              },
            ));
      } on FirebaseAuthException catch (error) {
        setState(() {
          isLoading = false;
        });
        final snackBar = SnackBar(
          content: Text(error.message.toString()),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppColors.red,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      return;
    }
  }

  // initialize the loading circle
  bool isLoading = false;

  // forgotten password function
  void navigateToForgottenPasswordPage() {
    Navigator.push(
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
            return const ForgottenPasswordPage();
          },
        ));
  }

  void navigateToRegisterPage() {
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
            return const RegisterPage();
          },
        ));
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: const Text(
            'Welcome Back \u{263A}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // welcome back text
                Text(
                  'We are happy to see you again. To use your account, you should log in first.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey700,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'e.g abc123@gmail.com',
                  icon: Icons.alternate_email_rounded,
                  title: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
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
                SizedBox(
                  height: 6.h,
                ),
                CustomTextField(
                  controller: passwordController,
                  icon: Icons.password_rounded,
                  title: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: isVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  obscureText: isVisible ? false : true,
                  onPressed: passwordVisibility,
                  maxLength: 15,
                  validator: (password) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~.]).{8,}$');
                    if (password != null && !regex.hasMatch(password)) {
                      return 'Password must contain at least: \n One uppercase letter \n One lowercase letter \n A digit \n One special symbol \n 8 characters';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: navigateToForgottenPasswordPage,
                    child: Text(
                      'Forgotten Password?',
                      style: TextStyle(
                        color: AppColors.deepPurple,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                CustomButton(
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
                SizedBox(
                  height: 15.h,
                ),
                // register text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register Here!',
                        style: TextStyle(
                          color: AppColors.deepPurple,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
