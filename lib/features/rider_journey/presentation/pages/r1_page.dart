import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/shared/widgets/recurring_widget.dart'; // Updated import
import 'package:vroo_test/shared/widgets/to_and_fro.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/input_ride_validator.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/date_picker.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/time_picker.dart';
import '../bloc/bloc/r1_bloc.dart';
import '../bloc/event/r1_event.dart';
import '../bloc/state/r1_state.dart';

class R1Page extends StatefulWidget {
  final SourceAndDestModel location;

  const R1Page({
    super.key,
    required this.location,
  });

  @override
  _R1PageState createState() => _R1PageState();
}

class _R1PageState extends State<R1Page> {
  // Recurring state variables
  bool isRecurring = false;
  String? frequency;
  Set<String>? selectedDays;
  DateTime? endDate;

  void _validateFields() {
    final state = context.read<R1Bloc>().state;

    if (state is ScheduleInputState) {
      // Apply validation rules
      final dateErrorMsg = InputRideValidator.validateDate(state.selectedDate);
      final minTimeErrorMsg =
          InputRideValidator.validateTime(state.minPickUpTime);
      final maxTimeErrorMsg =
          InputRideValidator.validateTime(state.maxPickUpTime);
      final arrivalTimeErrorMsg =
          InputRideValidator.validateTime(state.maxArrivalTime);
      
      // Validate time not in past for regular times
      final minTimeNotInPastErrorMsg = InputRideValidator.validateTimeNotInPast(
          state.minPickUpTime, state.selectedDate);
      final maxTimeNotInPastErrorMsg = InputRideValidator.validateTimeNotInPast(
          state.maxPickUpTime, state.selectedDate);
      
      // Validate max arrival time not in past (handles cross-midnight scenarios)
      final arrivalTimeNotInPastErrorMsg = InputRideValidator.validateMaxArrivalTimeNotInPast(
          state.maxArrivalTime, state.selectedDate, state.maxPickUpTime);
      
      final minMaxTimeErrorMsg = InputRideValidator.validateMinMaxTime(
          state.minPickUpTime, state.maxPickUpTime);
      final maxArrivalTimeErrorMsg = InputRideValidator.validateMaxArrivalTime(
          state.maxPickUpTime, state.maxArrivalTime);

      // Combine error messages (prioritize past time errors)
      String? combinedMinTimeError = minTimeNotInPastErrorMsg ?? minTimeErrorMsg;
      String? combinedMaxTimeError = maxTimeNotInPastErrorMsg ?? maxTimeErrorMsg ?? minMaxTimeErrorMsg;
      String? combinedArrivalTimeError = arrivalTimeNotInPastErrorMsg ?? arrivalTimeErrorMsg ?? maxArrivalTimeErrorMsg;

      // Show errors in UI via the bloc
      context.read<R1Bloc>().add(ShowErrorEvent(
            dateErrorText: dateErrorMsg,
            minTimeErrorText: combinedMinTimeError,
            maxTimeErrorText: combinedMaxTimeError,
            arrivalTimeErrorText: combinedArrivalTimeError,
            minMaxTimeErrorText: minMaxTimeErrorMsg,
            maxArrivalTimeErrorText: maxArrivalTimeErrorMsg,
          ));

      // If any error exists, stop processing
      if (dateErrorMsg != null ||
          combinedMinTimeError != null ||
          combinedMaxTimeError != null ||
          combinedArrivalTimeError != null ||
          minMaxTimeErrorMsg != null ||
          maxArrivalTimeErrorMsg != null) {
        return; // Stop further execution if validation fails
      }

      // Proceed with saving if all fields are valid
      final schedule = ScheduleModel(
        date: state.selectedDate!,
        minTime: state.minPickUpTime!,
        maxTime: state.maxPickUpTime!,
        arrivalTime: state.maxArrivalTime!,
        recurrenceType: isRecurring,
        frequency: isRecurring ? frequency : null,
        selectedDays: isRecurring ? selectedDays : null,
        endDate: isRecurring ? endDate : null,
      );

      context.read<R1Bloc>().add(SaveScheduleEvent(schedule));
      context.read<Navigation>().navigateTo('/r2_page', arguments: {
        'schedule': schedule,
        'location': widget.location,
      });
    }
  }

  void _onRecurrenceChanged(bool recurring, String? freq, Set<String>? days, DateTime? end) {
    setState(() {
      isRecurring = recurring;
      frequency = freq;
      selectedDays = days;
      endDate = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<R1Bloc, R1State>(
            builder: (context, state) {
              if (state is ScheduleSaved) {
                context.read<R1Bloc>().add(ResetStateEvent());
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              }
              if (state is ScheduleInitial) {
                context.read<R1Bloc>().add(LoadScheduleEvent());
              }
              if (state is ScheduleSaving) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              }
              if (state is ScheduleLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              } else if (state is ScheduleLoaded) {
                // Transition to ScheduleInputState with the loaded schedule
                final schedule = state.loadedSchedule;
                
                // Load recurring data from the loaded schedule
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    isRecurring = schedule.recurrenceType;
                    frequency = schedule.frequency;
                    selectedDays = schedule.selectedDays;
                    endDate = schedule.endDate;
                  });
                });

                context.read<R1Bloc>().add(UpdateScheduleEvent(
                      selectedDate: schedule.date,
                      minPickUpTime: schedule.minTime,
                      maxPickUpTime: schedule.maxTime,
                      maxArrivalTime: schedule.arrivalTime,
                    ));
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.progressIndicatorTheme.color!,
                    ),
                  ),
                );
              } else if (state is ScheduleInputState) {
                final bloc = context.read<R1Bloc>();

                return Scaffold(
                  appBar: CustomAppBar(
                    highlightedCircles: 1,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ToAndFroWidget(
                            fromDescription: widget.location.fromDescription,
                            toDescription: widget.location.toDescription,
                          ),
                          SizedBox(height: 22.h),
                          CustomDatePicker(
                            labelText: 'Select Date',
                            selectedDate: state.selectedDate,
                            onDateSelected: (pickedDate) {
                              bloc.add(SelectDateEvent(pickedDate));
                            },
                            errorText: state.dateErrorText,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Min Pick up Time',
                            selectedTime: state.minPickUpTime,
                            selectedDate: state.selectedDate, // Pass selected date
                            onTimeSelected: (pickedTime) {
                              bloc.add(
                                  SelectTimeEvent(pickedTime, "minPickUpTime"));
                              final maxPickUpTime = pickedTime.replacing(
                                minute: (pickedTime.minute + 15) % 60,
                                hour: pickedTime.minute + 15 >= 60
                                    ? pickedTime.hour + 1
                                    : pickedTime.hour,
                              );
                              bloc.add(SelectTimeEvent(
                                  maxPickUpTime, "maxPickUpTime"));
                            },
                            errorText: state.minTimeErrorText ??
                                state.minMaxTimeErrorText,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Max Pick up Time',
                            selectedTime: state.maxPickUpTime,
                            selectedDate: state.selectedDate, // Pass selected date
                            onTimeSelected: (pickedTime) {
                              bloc.add(
                                  SelectTimeEvent(pickedTime, "maxPickUpTime"));
                            },
                            errorText: state.maxTimeErrorText ??
                                state.minMaxTimeErrorText,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Max Arrival Time',
                            selectedTime: state.maxArrivalTime,
                            selectedDate: state.selectedDate, // Pass selected date
                            isMaxArrivalTime: true, // Mark as max arrival time picker
                            departureTime: state.maxPickUpTime, // Pass departure time for cross-midnight validation
                            onTimeSelected: (pickedTime) {
                              bloc.add(SelectTimeEvent(
                                  pickedTime, "maxArrivalTime"));
                            },
                            errorText: state.arrivalTimeErrorText ??
                                state.maxArrivalTimeErrorText,
                          ),
                          SizedBox(height: 12.h),
                          RecurringWidget(
                            initialIsRecurring: isRecurring,
                            initialFrequency: frequency,
                            initialSelectedDays: selectedDays,
                            initialEndDate: endDate,
                            onRecurrenceChanged: _onRecurrenceChanged,
                          ),
                          SizedBox(height: 12.h),
                          GradientButton(
                            onTap: () {
                              _validateFields();
                            },
                            text: 'Next',
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is ScheduleError) {
                return Center(
                  child: Text('Error loading schedule'),
                );
              } else {
                return Center(
                    child: Text('Unexpected state: ${state.runtimeType}'));
              }
            },
          )
        ],
      ),
    );
  }
}
