import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/rider_journey/data/model/schedule_model.dart';
import 'package:vroo_test/features/rider_journey/data/model/source_and_dest_model.dart';
import 'package:vroo_test/shared/widgets/recurring_row.dart';
import 'package:vroo_test/shared/widgets/to_and_fro.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/input_ride_validator.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/date_picker.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/recurrence_dialog.dart';
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
  DateTime? selectedDate;
  TimeOfDay? selectedMinTime;
  TimeOfDay? selectedMaxTime;
  TimeOfDay? maxArrivalTime;
  bool isRecurring = false;
  String recurrence = 'One Time';
  ScheduleModel? schedule;
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
      final minMaxTimeErrorMsg = InputRideValidator.validateMinMaxTime(
          state.minPickUpTime, state.maxPickUpTime);
      final maxArrivalTimeErrorMsg = InputRideValidator.validateMaxArrivalTime(
          state.maxPickUpTime, state.maxArrivalTime);

      // Show errors in UI via the bloc
      context.read<R1Bloc>().add(ShowErrorEvent(
            dateErrorText: dateErrorMsg,
            minTimeErrorText: minTimeErrorMsg,
            maxTimeErrorText: maxTimeErrorMsg,
            arrivalTimeErrorText: arrivalTimeErrorMsg,
            minMaxTimeErrorText: minMaxTimeErrorMsg,
            maxArrivalTimeErrorText: maxArrivalTimeErrorMsg,
          ));

      // If any error exists, stop processing
      if (dateErrorMsg != null ||
          minTimeErrorMsg != null ||
          maxTimeErrorMsg != null ||
          arrivalTimeErrorMsg != null ||
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
        recurrenceType: isRecurring ? recurrence : 'One Time',
      );

      context.read<R1Bloc>().add(SaveScheduleEvent(schedule));
      context.read<Navigation>().navigateTo('/r2_page', arguments: {
        'schedule': schedule,
        'location': widget.location,
      });
    }
  }

// Now let's update the build method in R1Page to correctly display error messages
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
                            onTimeSelected: (pickedTime) {
                              bloc.add(SelectTimeEvent(
                                  pickedTime, "maxArrivalTime"));
                            },
                            errorText: state.arrivalTimeErrorText ??
                                state.maxArrivalTimeErrorText,
                          ),
                          SizedBox(height: 12.h),
                          RecurringRow(
                            onRecurringTap: () {
                              showRecurrenceDialog(context);
                            },
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
