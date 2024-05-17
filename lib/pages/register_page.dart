// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/components/custom_textfield.dart';
import 'package:techassist_app/verify_email.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // formkey
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isVisible = false;
  // password visibility
  void passwordVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // register user
  Future<void> registerUser() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        // authenticate the user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        //  add user to firestore
        addUserDetails();

        await Future.delayed(
          const Duration(seconds: 5),
        );
        final snackBar = SnackBar(
          content: const Text('Registration Successful!'),
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
        // change the loading status
        setState(
          () {
            isLoading = false;
          },
        );
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

  // register user
  Future<void> addUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'Full Name': firstNameController.text.trim(),
      'Email Address': emailController.text.trim(),
      'Phone Number': phoneController.text.trim(),
    });
  }

  // initialize the loading circle
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: const Text(
            'Create A New Account \u{1F601}',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //register text
                Text(
                  'Please fill in the form to continue.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.grey700,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // first name field
                CustomTextField(
                  controller: firstNameController,
                  icon: Icons.person,
                  title: 'Full Name',
                  obscureText: false,
                  hintText: 'e.g John Doe',
                  maxLength: 50,
                  validator: (name) {
                    if (name != null && firstNameController.text.isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                // email address field
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
                  height: 2.h,
                ),
                // phone number field
                CustomTextField(
                  controller: phoneController,
                  icon: Icons.phone,
                  title: 'Phone Number',
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  hintText: 'e.g 1234567890',
                  maxLength: 11,
                  validator: (number) {
                    if (number != null && phoneController.text.isEmpty) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                // password field
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
                SizedBox(
                  height: 2.h,
                ),
                // password field
                CustomTextField(
                  controller: confirmPasswordController,
                  icon: Icons.password_rounded,
                  title: 'Confirm Password',
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: isVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  obscureText: isVisible ? false : true,
                  onPressed: passwordVisibility,
                  maxLength: 15,
                  validator: (password) {
                    if (password != null &&
                        confirmPasswordController.text !=
                            passwordController.text) {
                      return 'Password mismatched!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  onPressed: isLoading ? null : registerUser,
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
                    const Text('Already have an account?'),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login Here!',
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
