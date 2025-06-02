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
    if (arrivalTimeInMinutes <= maxPickupTimeInMinutes) {
      return 'Arrival time must be greater than Max pickup time.';
    }
    return null;
  }

  static String? validateMaxArrTime(
      TimeOfDay? maxArrivalTime, TimeOfDay? departureTime) {
    if (maxArrivalTime == null || departureTime == null) {
      return 'Both maximum pickup time and departure time must be selected.';
    }
    final maxPickupTimeInMinutes =
        maxArrivalTime.hour * 60 + maxArrivalTime.minute;
    final arrivalTimeInMinutes = departureTime.hour * 60 + departureTime.minute;
    if (arrivalTimeInMinutes <= maxPickupTimeInMinutes) {
      return 'Arrival time must be greater than Departure time.';
    }
    return null;
  }
}
