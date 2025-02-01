import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vroo_test/features/driver_booking/data/model/schedule_model.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/date_picker.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/recurrence_dialog.dart';
import '../../../../shared/widgets/recurring_row.dart';
import '../../../../shared/widgets/time_picker.dart';
import '../../../../shared/widgets/to_and_fro.dart';
import '../bloc/bloc/d1_bloc.dart';
import '../bloc/event/d1_event.dart';
import '../bloc/state/d1_state.dart';

class D1Page extends StatefulWidget {
  final String fromDescription;
  final String toDescription;
  final String fromPlaceId;
  final String toPlaceId;
  final List<dynamic> selectedRouteCoords;
  final String distance;
  final String duration;

  const D1Page({
    super.key,
    required this.fromDescription,
    required this.toDescription,
    required this.fromPlaceId,
    required this.toPlaceId,
    required this.selectedRouteCoords,
    required this.distance,
    required this.duration,
  });

  @override
  _D1PageState createState() => _D1PageState();
}

class _D1PageState extends State<D1Page> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TimeOfDay? maxArrivalTime;
  bool isRecurring = false;
  String recurrence = 'One Time';
  ScheduleModel? schedule;

  void _validateFields() {
    final state = context.read<D1Bloc>().state;
    if (state is ScheduleInputState) {
      // Check for null values and add errors if necessary
      context.read<D1Bloc>().add(ShowErrorEvent(
            dateError: state.selectedDate == null,
            timeError: state.selectedTime == null,
            maxArrivalTimeError: state.maxArrivalTime == null,
          ));

      // Proceed only if all fields are valid
      if (state.selectedDate != null &&
          state.selectedTime != null &&
          state.maxArrivalTime != null) {
        final schedule = ScheduleModel(
          fromDescription: widget.fromDescription,
          toDescription: widget.toDescription,
          date: state.selectedDate!,
          time: state.selectedTime!,
          maxArrivalTime: state.maxArrivalTime!,
          recurrenceType: isRecurring ? recurrence : 'One Time',
        );

        context.read<D1Bloc>().add(SaveScheduleEvent(schedule));
        Navigator.pushNamed(
          context,
          Routes.d2,
          arguments: {
            'toPlaceID': widget.toPlaceId,
            'fromPlaceID': widget.fromPlaceId,
            'toDescription': widget.toDescription,
            'fromDescription': widget.fromDescription,
            'selectedRouteCoords': widget.selectedRouteCoords,
            'distance': widget.distance,
            'duration': widget.duration,
            'selectedDate': state.selectedDate!.toIso8601String(),
            'selectedTime': state.selectedTime.toString(),
            'maxArrivalTime': state.maxArrivalTime!.toString(),
            'isRecurring': isRecurring,
            'recurrence': recurrence,
          },
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<D1Bloc, D1State>(
            builder: (context, state) {
              if (state is ScheduleSaved) {
                context.read<D1Bloc>().add(ResetStateEvent());
                      return const Center(child: CircularProgressIndicator());

              }
              if (state is ScheduleInitial) {
                context.read<D1Bloc>().add(LoadScheduleEvent());
              }
              if (state is ScheduleLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ScheduleLoaded) {
                // Transition to ScheduleInputState with the loaded schedule
                final schedule = state.loadedSchedule;
                context.read<D1Bloc>().add(UpdateScheduleEvent(
                      selectedDate: schedule.date,
                      selectedTime: schedule.time,
                      maxArrivalTime: schedule.maxArrivalTime,
                    ));
                return Center(child: CircularProgressIndicator());
              } else if (state is ScheduleInputState) {
                final bloc = context.read<D1Bloc>();

                return Scaffold(
                  appBar: CustomAppBar(
                    highlightedCircles: 1,
                  ),
                  body: Padding(
                    padding: EdgeInsets.all(12.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          ToAndFroWidget(
                            fromDescription: widget.fromDescription,
                            toDescription: widget.toDescription,
                          ),
                          SizedBox(height: 30.h),
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
                            labelText: 'Departure Time',
                            selectedTime: state.selectedTime,
                            onTimeSelected: (departureTime) {
                              bloc.add(
                                  SelectTimeEvent(departureTime, "time"));
                            },
                            errorText: state.timeError
                                ? 'Please select departure time'
                                : null,
                          ),
                          
                          SizedBox(height: 12.h),
                          CustomTimePicker(
                            labelText: 'Max Arrival Time',
                            selectedTime: state.maxArrivalTime,
                            onTimeSelected: (departureTime) {
                              bloc.add(SelectTimeEvent(
                                  departureTime, "maxArrivalTime"));
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
                          SizedBox(height: 15.h),
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
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                  // child: Text('Unexpected state: ${state.runtimeType}')
                );
              }
            },
          )
        ],
      ),
    );
  }
}
