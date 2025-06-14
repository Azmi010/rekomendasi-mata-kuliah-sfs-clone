import 'package:flutter/material.dart';

TimeOfDay? tryParseTimeOfDayRobust(String? timeStr) {
  if (timeStr == null || timeStr.isEmpty) {
    return null;
  }
  
  String T = timeStr.trim().toUpperCase();
  final RegExp timeRegex = RegExp(
      r"(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)?");
  final Match? match = timeRegex.firstMatch(T);

  if (match == null) {
    print("Format waktu tidak valid (regex mismatch): '$timeStr'.");
    return null;
  }

  try {
    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String? ampm = match.group(4);

    if (hour < 0 || hour > 23 && ampm == null) {
         print("Jam tidak valid dalam format 24H: $hour untuk waktu '$timeStr'.");
        return null;
    }
     if (ampm != null && (hour < 1 || hour > 12) ) {
        print("Jam tidak valid dalam format 12H: $hour untuk waktu '$timeStr'.");
        return null;
    }


    if (ampm != null) {
      if (ampm == "PM" && hour != 12) {
        hour += 12;
      } else if (ampm == "AM" && hour == 12) {
        hour = 0;
      }
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      print("Nilai jam/menit tidak valid setelah parsing: '$timeStr' -> Jam:$hour, Menit:$minute.");
      return null;
    }
    
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    print("Error saat parsing komponen dari '$timeStr': $e");
    return null;
  }
}

int timeOfDayToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

bool doTimesOverlapInternal({
  required TimeOfDay? newCourseStart,
  required TimeOfDay? newCourseEnd,
  required TimeOfDay? existingCourseStart,
  required TimeOfDay? existingCourseEnd,
}) {
  if (newCourseStart == null || newCourseEnd == null || existingCourseStart == null || existingCourseEnd == null) {
    return false;
  }

  final newStartMinutes = timeOfDayToMinutes(newCourseStart);
  final newEndMinutes = timeOfDayToMinutes(newCourseEnd);
  final existingStartMinutes = timeOfDayToMinutes(existingCourseStart);
  final existingEndMinutes = timeOfDayToMinutes(existingCourseEnd);

  if (newStartMinutes >= newEndMinutes || existingStartMinutes >= existingEndMinutes) {
    return false;
  }

  return newStartMinutes < existingEndMinutes && newEndMinutes > existingStartMinutes;
}