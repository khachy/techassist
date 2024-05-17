// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/formats.dart';
import 'package:techassist_app/components/status_tile.dart';
import 'package:techassist_app/models/ticket_list.dart';
import 'package:techassist_app/models/ticket_model.dart';
// import 'package:techassist_app/pages/ticket_details.dart';
import 'package:path_provider/path_provider.dart';

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  const TicketTile({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketLists>(
      builder: (context, ticketLists, _) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 12.w,
            ),
            height: 200.h,
            width: 400.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusTile(),
                    Row(
                      children: [
                          ticket.priorityIcon,
                          
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          ticket.priorityText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ticket.priorityColor,
                            fontSize: 16.sp,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // title of ticket
                Row(
                  children: [
                    Text(
                      ticket.ticketID,
                      style: TextStyle(
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ticket.ticketName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                // description
                Expanded(
                  child: Text(
                    ticket.description,
                    style: TextStyle(
                      color: AppColors.grey700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: 25.h,
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              basename(ticket.selectedFile),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepPurple,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '(${ticket.fileLength})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => downloadFile(
                          context,
                          ticket.selectedFile,
                          basename(ticket.selectedFile),
                        ),
                        child: Icon(
                          Iconsax.document_download,
                          size: 15,
                          color: AppColors.deepPurple,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // date
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar,
                          color: AppColors.grey700,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          Formats.toDate(ticket.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Iconsax.clock,
                          color: AppColors.grey700,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          Formats.toTime(ticket.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey700,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadFile(BuildContext context, String filePath, String fileName) async {
    try {
      // Request storage permission
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        // Get the directory for the downloads
        Directory? downloadsDirectory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();

        if (downloadsDirectory != null) {
          // Check if the directory exists, if not, create it
          String downloadPath = '${downloadsDirectory.path}/Download';
          Directory(downloadPath).createSync(recursive: true);

          // 1. Read the local file
          var localFile = File(filePath);
          if (await localFile.exists()) {
            var fileBytes = await localFile.readAsBytes();

            // 2. Write the local file content to the download location
            String newFilePath = '$downloadPath/$fileName';
            await File(newFilePath).writeAsBytes(fileBytes);

            // Show a success message
            final snackBar = SnackBar(
              content: Text('File downloaded successfully: $newFilePath'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h,),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              backgroundColor: AppColors.green,
              duration: const Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            // Handle case where local file doesn't exist
            print('Error: Local file does not exist: $filePath');
            // Show an error message to the user
          }
        } else {
          // Show an error message if directory is null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error downloading file: Could not access storage directory'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show a message if permission is denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission denied: Cannot download file without storage permission'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error downloading file: $e');
      // Show an error message to the user
    }
  }
}
