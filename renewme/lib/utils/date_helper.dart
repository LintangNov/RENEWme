import 'package:intl/intl.dart';

String formatPickupTime(DateTime startTime, DateTime endTime) {
 
  final timeFormat = DateFormat('HH:mm', 'id_ID');
  final dayFormat = DateFormat('EEEE', 'id_ID'); // nama hari lengkap

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final pickupDay = DateTime(startTime.year, startTime.month, startTime.day);

  String dayString;

  if (pickupDay == today) {
    dayString = 'Hari ini';
  } else if (pickupDay == tomorrow) {
    dayString = 'Besok';
  } else {
    dayString = dayFormat.format(startTime); 
  }

  final String startTimeString = timeFormat.format(startTime);
  final String endTimeString = timeFormat.format(endTime);

  return '$dayString, pukul $startTimeString - $endTimeString';
}