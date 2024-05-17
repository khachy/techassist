import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formats {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat('E, MMM d, y').format(dateTime);

    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat('hh:mm a').format(dateTime);

    return time;
  }

  static String forStartTime(DateTime dateTime) {
    final time = DateFormat('MMM, d, y').format(dateTime);

    return time;
  }

  static String forTimeOfDay(TimeOfDay timeOfDay, BuildContext context) {
    final time = timeOfDay.format(context);

    return time;
  }
}
