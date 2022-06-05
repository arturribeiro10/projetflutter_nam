import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(100000);
}

class NotificationDateAndTime {
  final DateTime date;
  final TimeOfDay timeOfDay;

  NotificationDateAndTime({
    required this.date,
    required this.timeOfDay,
  });
}

/*
 * Author : Manuel
 */
