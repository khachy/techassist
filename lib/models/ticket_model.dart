import 'package:flutter/material.dart';

class Ticket {
  final String ticketID;
  final String ticketName;
  final String description;
  final String selectedFile;
  final DateTime time;
  final DateTime date;
  final String fileLength;
  Color priorityColor;
  String priorityText;
  Icon priorityIcon;

  Ticket({
    required this.ticketID,
    required this.ticketName,
    required this.description,
    required this.selectedFile,
    required this.time,
    required this.date,
    required this.fileLength,
    required this.priorityColor,
    required this.priorityText,
    required this.priorityIcon,
  });
}
