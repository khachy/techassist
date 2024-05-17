import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/faq_tile.dart';
import 'package:techassist_app/models/faq_model.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text('Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            // everything you need...text
            const Text('Have questions? We\'ve got answers! Our FAQ section is here to help you navigate through any technical challenges you may encounter.'),
            SizedBox(
              height: 25.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: FaqModel().faqs.length,
                itemBuilder: (context, index) {
                  return FaqTile(faqText: FaqModel().faqs[index][0], faqAnswer: FaqModel().faqs[index][1]);
                },
                ),
              )
          ],
        ),
      ),
    );
  }
} 