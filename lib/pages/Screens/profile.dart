import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('User not found');
            }

            // Extract user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final fullName = userData['Full Name'] ?? 'Unknown';
            final emailAddress = userData['Email Address'] ?? 'Unknown';
            final phoneNumber = userData['Phone Number'] ?? 'Unknown';

            // Extract initials
            final initials = _getInitials(fullName);

            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // circle avatar
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.deepPurple,
                    child: Text(
                      initials,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        const Text('Email Address:'),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          emailAddress,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        const Text('Phone Number:'),
                        SizedBox(
                          width: 15.w,
                        ),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  String _getInitials(String fullName) {
    // Split full name by space and take the first character of each part
    List<String> parts = fullName.split(' ');
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
    }
    return initials;
  }
}
