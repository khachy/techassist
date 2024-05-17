import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/pages/Screens/chat.dart';
import 'package:techassist_app/pages/Screens/dashboard.dart';
import 'package:techassist_app/pages/Screens/faq.dart';
import 'package:techassist_app/pages/Screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80.h,
        elevation: 0,
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.blue50,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.ticket),
            label: 'Tickets',
            selectedIcon: Icon(
              Iconsax.ticket,
              color: AppColors.deepPurple,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.message),
            label: 'Chats',
            selectedIcon: Icon(
              Iconsax.message,
              color: AppColors.deepPurple,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.message_question),
            label: 'FAQ',
            selectedIcon: Icon(
              Iconsax.message_question,
              color: AppColors.deepPurple,
            ),
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            label: 'Profile',
            selectedIcon: Icon(
              Iconsax.user,
              color: AppColors.deepPurple,
            ),
          ),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}

final screens = [
  const Dashboard(),
  const Chats(),
  const FAQ(),
  const Profile(),
];
