import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:techassist_app/components/colors.dart';
// import 'package:techassist_app/models/faq_model.dart';

class FaqTile extends StatefulWidget {
  final String faqText;
  final String faqAnswer;
  const FaqTile({super.key, required this.faqText, required this.faqAnswer});

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool isVisible = false;
  void showFAQ() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Container(
        height: isVisible ? 104.h : 44.h,
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.faqText,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                ),
                GestureDetector(
                  onTap: () => showFAQ(),
                  child: Icon(
                    isVisible ? Iconsax.minus_cirlce : Iconsax.add_circle,
                    size: 20,
                    // color: AppColors.deepPurple,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Expanded(
                child: Visibility(
                  visible: isVisible ? true : false,
                  child: Text(widget.faqAnswer),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
