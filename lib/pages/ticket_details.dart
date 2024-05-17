import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/components/custom_button.dart';
import 'package:techassist_app/components/priority_tile.dart';
import 'package:techassist_app/models/ticket_model.dart';
// import 'package:techassist_app/models/priority.dart';
import 'package:techassist_app/models/ticket_list.dart';
// import 'package:techassist_app/pages/Screens/dashboard.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({Key? key}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  final ticketNameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;
  File? selectedFile;
  Color selectedPriorityColor = Colors.black;
  String selectedPriorityText = '';
  Icon selectedPriorityIcon = const Icon(Iconsax.archive_slash);

  @override
  void dispose() {
    ticketNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        showCursor: true,
                        controller: ticketNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter Ticket Name',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value != null &&
                              ticketNameController.text.isEmpty) {
                            return 'Please enter a ticket name!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      PriorityTile(
                        onPrioritySelected: (color, text, icon) {
                          setState(() {
                            selectedPriorityColor = color;
                            selectedPriorityText = text;
                            selectedPriorityIcon = icon;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: descriptionController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.blue50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        validator: (value) {
                          if (value != null &&
                              descriptionController.text.isEmpty) {
                            return 'Please explain the problem here!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => pickFile(),
                            child: const Icon(Iconsax.attach_circle),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              selectedFile != null
                                  ? basename(selectedFile!.path)
                                  : 'Attach a file (Use simple file name)',
                              style: TextStyle(
                                color: selectedFile != null
                                    ? AppColors.deepPurple
                                    : Colors.grey.shade400,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          Text(
                            selectedFile != null ? getFileLength() : '',
                            style: TextStyle(
                              color: selectedFile != null
                                  ? AppColors.deepPurple
                                  : Colors.grey.shade400,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h),
                      CustomButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          if (selectedFile == null) {
                            final snackBar = SnackBar(
                              content: const Text(
                                  'Please attach a file for clarification'),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (isValid) {
                            String ticketID = generateTicketID();
                            isLoading = true;

                            // Create a new TicketModel with selected priority
                            Ticket newTicket = Ticket(
                              ticketID: ticketID,
                              ticketName: ticketNameController.text.trim(),
                              description: descriptionController.text.trim(),
                              priorityText: selectedPriorityText,
                              priorityColor: selectedPriorityColor,
                              selectedFile: selectedFile!.path,
                              time: DateTime.now(),
                              date: DateTime.now(),
                              fileLength: getFileLength(),
                              priorityIcon: selectedPriorityIcon,
                            );

                            // Add the new ticket to the list
                            Provider.of<TicketLists>(context, listen: false)
                                .addTicket(newTicket);

                            // Show success snackbar
                            final snackBar = SnackBar(
                              content: const Text('Ticket added successfully'),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            // Navigate to dashboard or other screen
                            Navigator.pop(context);
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Add Ticket',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ])))));
  }

  String generateTicketID() {
    // Generate a random number between 0 and 999
    Random random = Random();
    int randomNumber = random.nextInt(1000);

    // Format the random number with leading zeros if necessary
    String formattedRandomNumber = randomNumber.toString().padLeft(3, '0');

    // Concatenate the formatted random number with the ID prefix
    return '#ID-$formattedRandomNumber';
  }

  String getFileLength() {
    if (selectedFile != null) {
      int length = selectedFile!.lengthSync();
      const int kb = 1024;
      const int mb = 1024 * kb;
      const int gb = 1024 * mb;

      if (length >= gb) {
        return '${(length / gb).toStringAsFixed(2)} GB';
      } else if (length >= mb) {
        return '${(length / mb).toStringAsFixed(2)} MB';
      } else if (length >= kb) {
        return '${(length / kb).toStringAsFixed(2)} KB';
      } else {
        return '$length B';
      }
    }
    return '';
  }

  Future<void> pickFile() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      }
    }
  }
}
