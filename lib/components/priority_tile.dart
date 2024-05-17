import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/models/priority.dart';
// import 'package:techassist_app/components/colors.dart';

class PriorityTile extends StatefulWidget {
  final Function(Color color, String text, Icon icon) onPrioritySelected;

  const PriorityTile({
    Key? key,
    required this.onPrioritySelected,
  }) : super(key: key);

  @override
  State<PriorityTile> createState() => _PriorityTileState();
}

class _PriorityTileState extends State<PriorityTile> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Priority',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Expanded(
                child: SizedBox(
                  height: 40.h,
                  width: 285.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Priority().priority.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              Color selectedColor =
                                  Priority().priority[index][2] as Color;
                              String selectedText =
                                  Priority().priority[index][1].toString();
                              Icon icon = Priority().priority[index][0];
                              widget.onPrioritySelected(selectedColor, selectedText, icon);
                            });
                          },
                          child: Container(
                            height: 40.h,
                            width: 80.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: (index == selectedIndex)
                                    ? Priority().priority[index][2] as Color
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              color: (index == selectedIndex)
                                  ? Priority().priority[index][3] as Color
                                  : AppColors.whiteColor,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Priority().priority[index][0],
                                  SizedBox(width: 8.w),
                                  Text('${Priority().priority[index][1]}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
