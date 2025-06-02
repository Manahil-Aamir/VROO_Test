import 'package:flutter/material.dart';

class InputRideValidator {
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date.';
    }
    return null;
  }

  static String? validateTime(TimeOfDay? time) {
    if (time == null) {
      return 'Please select a time.';
    }
    return null;
  }

  static String? validateMinMaxTime(TimeOfDay? minTime, TimeOfDay? maxTime) {
    if (minTime == null || maxTime == null) {
      return 'Both minimum and maximum times must be selected.';
    }
    final minTimeInMinutes = minTime.hour * 60 + minTime.minute;
    final maxTimeInMinutes = maxTime.hour * 60 + maxTime.minute;
    if (minTimeInMinutes >= maxTimeInMinutes) {
      return 'Min time must be less than Max time.';
    }
    if (maxTimeInMinutes - minTimeInMinutes < 15) {
      return 'Max time must be at least 15 minutes greater than Min time.';
    }
    return null;
  }

  static String? validateMaxArrivalTime(
      TimeOfDay? maxPickupTime, TimeOfDay? arrivalTime) {
    if (maxPickupTime == null || arrivalTime == null) {
      return 'Both maximum pickup time and arrival time must be selected.';
    }
    final maxPickupTimeInMinutes =
        maxPickupTime.hour * 60 + maxPickupTime.minute;
    final arrivalTimeInMinutes = arrivalTime.hour * 60 + arrivalTime.minute;
    if (arrivalTimeInMinutes < maxPickupTimeInMinutes) {
      return 'Arrival time must be equal to or later than Max pickup time.';
    }
    return null;
  }

  // static String? validateTimeNotInPast(TimeOfDay? time, DateTime? date, {bool isMaxArrivalTime = false, TimeOfDay? departureTime}) {
  //   if (time == null || date == null) return null;
    
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final selectedDay = DateTime(date.year, date.month, date.day);
    
  //   // Only check if the selected date is today
  //   if (selectedDay.isAtSameMomentAs(today)) {
  //     DateTime selectedDateTime;
      
  //     if (isMaxArrivalTime && departureTime != null) {
  //       // For max arrival time, check if it's next day scenario
  //       bool isNextDay = _isTimeNextDay(departureTime, time);
        
  //       if (isNextDay) {
  //         // If max arrival time is next day, add 1 day
  //         selectedDateTime = DateTime(
  //           date.year,
  //           date.month,
  //           date.day + 1,
  //           time.hour,
  //           time.minute,
  //         );
  //       } else {
  //         selectedDateTime = DateTime(
  //           date.year,
  //           date.month,
  //           date.day,
  //           time.hour,
  //           time.minute,
  //         );
  //       }
  //     } else {
  //       selectedDateTime = DateTime(
  //         date.year,
  //         date.month,
  //         date.day,
  //         time.hour,
  //         time.minute,
  //       );
  //     }
      
  //     if (selectedDateTime.isBefore(now)) {
  //       return 'Cannot select a time in the past for today';
  //     }
  //   }
    
  //   return null;
  // }

  static bool _isTimeNextDay(TimeOfDay startTime, TimeOfDay endTime) {
    // Convert times to minutes for easy comparison
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    
    // If end time is smaller than start time, it means it's next day
    return endMinutes < startMinutes;
  }

// Add these methods to your InputRideValidator class:

static String? validateTimeNotInPast(TimeOfDay? time, DateTime? date) {
  if (time == null || date == null) return null;
  
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selectedDay = DateTime(date.year, date.month, date.day);
  
  // Only check if the selected date is today
  if (selectedDay.isAtSameMomentAs(today)) {
    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    
    if (selectedDateTime.isBefore(now)) {
      return 'Cannot select a time in the past for today';
    }
  }
  
  return null;
}

static String? validateMaxArrivalTimeNotInPast(TimeOfDay? maxArrivalTime, DateTime? date, TimeOfDay? departureTime) {
  if (maxArrivalTime == null || date == null) return null;
  
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selectedDay = DateTime(date.year, date.month, date.day);
  
  // Only check if the selected date is today
  if (selectedDay.isAtSameMomentAs(today)) {
    DateTime maxArrivalDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      maxArrivalTime.hour,
      maxArrivalTime.minute,
    );
    
    // If departure time is provided, check for cross-midnight scenario
    if (departureTime != null) {
      final departureDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        departureTime.hour,
        departureTime.minute,
      );
      
      // If max arrival time is earlier than departure time, it's next day
      if (maxArrivalDateTime.isBefore(departureDateTime)) {
        // For next day scenarios, we don't validate against current time
        // because it's a future time (next day)
        return null;
      }
    }
    
    if (maxArrivalDateTime.isBefore(now)) {
      return 'Max arrival time cannot be in the past';
    }
  }
  
  return null;
}
}
