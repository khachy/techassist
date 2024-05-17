// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/ticket_tile.dart';
import 'package:techassist_app/models/ticket_list.dart';
// import 'package:techassist_app/models/ticket_model.dart';
import 'package:techassist_app/pages/ticket_details.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final filter = [
    'Priority Level',
    'Ticket Status',
    'Ticket ID',
    'Ticket Date',
  ];
  String? selectedValue = 'Priority Level';
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.whiteColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.deepPurple,
              child: Icon(
                Iconsax.add,
                color: AppColors.whiteColor,
                size: 25.sp,
              ),
              onPressed: () {
                Navigator.push(
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
                        return const AddTicket();
                      },
                    ));
              },
            ),
            body: Consumer<TicketLists>(builder: (context, ticketLists, _) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text('User not found');
                    }

                    // Extract user data
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final fullName = userData['Full Name'] ??
                        'Unknown'; // Get user's full name from Firestore

                    // Extract initials
                    final initials = _getInitials(fullName);

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          // profile
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.deepPurple,
                                    radius: 30.r,
                                    child: Center(
                                      child: Text(
                                        initials,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // greetings
                                      const Text('Happy to see you,'),
                                      Text(
                                        fullName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Iconsax.notification)
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // my ticket text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Tickets',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Center(
                                      child: Text(
                                    '(${ticketLists.tickets.length})',
                                    style: const TextStyle(
                                      color: AppColors.deepPurple,
                                    ),
                                  )),
                                ],
                              ),
                              // drop down buton
                              Row(
                                children: [
                                  const Text('Filter By:'),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  DropdownButton<String>(
                                      value: selectedValue,
                                      // isExpanded: true,
                                      icon: const Icon(
                                        Iconsax.arrow_down,
                                      ),
                                      underline: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide.none)),
                                      ),
                                      items: filter
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              ))
                                          .toList(),
                                      onChanged: (value) => setState(
                                          () => selectedValue = value)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // tickets
                          ticketLists.tickets.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: ticketLists.tickets.length,
                                    itemBuilder: (context, index) {
                                      // Pass each ticket to the TicketTile widget
                                      return TicketTile(
                                        ticket: ticketLists.tickets[index],
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 150.h,
                                      ),
                                      Icon(
                                        Iconsax.emoji_sad,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text('No tickets added yet!'),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    );
                  });
            }),
          ),
        ));
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
