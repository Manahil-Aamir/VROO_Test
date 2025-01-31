import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/rider_journey/dependancy_injection/r1_di.dart';
import 'package:vroo_test/shared/widgets/recurring_row.dart';
import 'package:vroo_test/shared/widgets/to_and_fro.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/validators/input_ride_validator.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/date_picker.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/recurrence_dialog.dart';
import '../../../../shared/widgets/time_picker.dart';
import '../../domain/entity/schedule_model.dart';
import '../bloc/bloc/r1_bloc.dart';
import '../bloc/event/r1_event.dart';
import '../bloc/state/r1_state.dart';

class R1Page extends StatefulWidget {
  final String fromDescription;
  final String toDescription;
  final String fromPlaceId;
  final String toPlaceId;

  const R1Page({
    super.key,
    required this.fromDescription,
    required this.toDescription,
    required this.fromPlaceId,
    required this.toPlaceId,
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
  Schedule? schedule;

  final bool _dateError = false;
  final bool _timeError = false;
  final bool _timeError2 = false;
  final bool _timeError3 = false;
  final bool _minMaxTimeError = false;
  final bool _maxArrivalTimeError = false;
  final bool _isDialogOpen = false;

  final bool _isInitialLoad = true;
  void _validateFields() {
    final state = context.read<R1Bloc>().state;
    if (state is ScheduleInputState) {
      // Check for null values and add errors if necessary
      context.read<R1Bloc>().add(ShowErrorEvent(
            dateError: state.selectedDate == null,
            minTimeError: state.minPickUpTime == null,
            maxTimeError: state.maxPickUpTime == null,
            arrivalTimeError: state.maxArrivalTime == null,
          ));

      // Proceed only if all fields are valid
      if (state.selectedDate != null &&
          state.minPickUpTime != null &&
          state.maxPickUpTime != null &&
          state.maxArrivalTime != null) {
        final schedule = Schedule(
          fromDescription: widget.fromDescription,
          toDescription: widget.toDescription,
          date: state.selectedDate!,
          minTime: state.minPickUpTime!,
          maxTime: state.maxPickUpTime!,
          arrivalTime: state.maxArrivalTime!,
          recurrenceType: isRecurring ? recurrence : 'One Time',
        );

        context.read<R1Bloc>().add(SaveScheduleEvent(schedule));
        context
            .read<Navigation>()
            .navigateTo('/location_selection', arguments: {
          'role': 'rider',
        });
      } else {
        // Show an error message if any field is null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all fields.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void onRecurringTap(BuildContext context) {
    showRecurrenceDialog(context);
  }

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_isInitialLoad) {
  //       context.read<R1Bloc>().add(LoadScheduleEvent());
  //       _isInitialLoad = false;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<R1Bloc, R1State>(
            builder: (context, state) {
              if (state is ScheduleSaved) {
                context.read<R1Bloc>().add(ResetStateEvent());
              }
              if (state is ScheduleInitial) {
                context.read<R1Bloc>().add(LoadScheduleEvent());
              }
              if (state is ScheduleLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ScheduleLoaded) {
                // Transition to ScheduleInputState with the loaded schedule
                final schedule = state.loadedSchedule;
                context.read<R1Bloc>().add(UpdateScheduleEvent(
                      selectedDate: schedule.date,
                      minPickUpTime: schedule.minTime,
                      maxPickUpTime: schedule.maxTime,
                      maxArrivalTime: schedule.arrivalTime,
                    ));
                return Center(child: CircularProgressIndicator());
              } else if (state is ScheduleInputState) {
                final bloc = context.read<R1Bloc>();

                return Scaffold(
                  appBar: CustomAppBar(
                    highlightedCircles: 1,
                    totalCircles: 3,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ToAndFroWidget(
                            fromDescription: widget.fromDescription,
                            toDescription: widget.toDescription,
                          ),
                          SizedBox(height: 12.h),
                          CustomDatePicker(
                            labelText: 'Select Date',
                            selectedDate: state.selectedDate,
                            onDateSelected: (pickedDate) {
                              bloc.add(SelectDateEvent(pickedDate));
                            },
                            errorText:
                                state.dateError ? 'Please select a date' : null,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Min Pick up Time',
                            selectedTime: state.minPickUpTime,
                            onTimeSelected: (pickedTime) {
                              bloc.add(
                                  SelectTimeEvent(pickedTime, "minPickUpTime"));
                            },
                            errorText: state.minTimeError
                                ? 'Please select a time'
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Max Pick up Time',
                            selectedTime: state.maxPickUpTime,
                            onTimeSelected: (pickedTime) {
                              bloc.add(
                                  SelectTimeEvent(pickedTime, "maxPickUpTime"));
                            },
                            errorText: state.maxTimeError
                                ? 'Please select a time'
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Max Arrival Time',
                            selectedTime: state.maxArrivalTime,
                            onTimeSelected: (pickedTime) {
                              bloc.add(SelectTimeEvent(
                                  pickedTime, "maxArrivalTime"));
                            },
                            errorText: state.arrivalTimeError
                                ? 'Please select a time'
                                : null,
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
