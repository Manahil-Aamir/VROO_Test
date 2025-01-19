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
import '../../../../shared/widgets/input_field.dart';
import '../../../../shared/widgets/recurrence_dialog.dart';
import '../../../../shared/widgets/time_picker.dart';
import '../../domain/model/schedule_model.dart';
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

  final bool _dateError = false;
  final bool _timeError = false;
  final bool _timeError2 = false;
  final bool _timeError3 = false;
  final bool _minMaxTimeError = false;
  final bool _maxArrivalTimeError = false;
  final bool _isDialogOpen = false;

  void _validateFields() {
    context.read<R1Bloc>().add(ShowErrorEvent(
          dateError: InputRideValidator.validateDate(selectedDate) != null,
          minTimeError:
              InputRideValidator.validateTime(selectedMinTime) != null,
          maxTimeError:
              InputRideValidator.validateTime(selectedMaxTime) != null,
          arrivalTimeError:
              InputRideValidator.validateTime(maxArrivalTime) != null,
          minMaxTimeError: InputRideValidator.validateMinMaxTime(
                  selectedMinTime, selectedMaxTime) !=
              null,
          maxArrivalTimeError: InputRideValidator.validateMaxArrivalTime(
                  selectedMaxTime, maxArrivalTime) !=
              null,
        ));

    if (!_dateError &&
        !_timeError &&
        !_timeError2 &&
        !_minMaxTimeError &&
        !_maxArrivalTimeError) {
      final schedule = Schedule(
        fromDescription: widget.fromDescription,
        toDescription: widget.toDescription,
        date: selectedDate!,
        minTime: selectedMinTime!,
        maxTime: selectedMaxTime!,
        recurrenceType: isRecurring ? recurrence : 'One Time',
      );

      context.read<R1Bloc>().add(SaveScheduleEvent(schedule));
      context.read<Navigation>().navigateTo('/location_selection', arguments: {
        'role': 'rider',
      });
    }
  }

  void onRecurringTap(BuildContext context) {
    showRecurrenceDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: R1DependencyInjection.init(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<R1Bloc, R1State>(
              builder: (context, state) {
                if (state is ScheduleInputState) {
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
                              errorText: state.dateError
                                  ? 'Please select a date'
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            CustomTimePicker(
                              labelText: 'Min Pick up Time',
                              selectedTime: state.minPickUpTime,
                              onTimeSelected: (pickedTime) {
                                bloc.add(SelectTimeEvent(
                                    pickedTime, "minPickUpTime"));
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
                                bloc.add(SelectTimeEvent(
                                    pickedTime, "maxPickUpTime"));
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
                                onRecurringTap: () => onRecurringTap(context)),
                            SizedBox(height: 12.h),
                            GradientButton(
                              onTap: () {
                                // Trigger field validation through the Bloc.
                                bloc.add(ShowErrorEvent(
                                  dateError: state.selectedDate == null,
                                  minTimeError: state.minPickUpTime == null,
                                  maxTimeError: state.maxPickUpTime == null,
                                  arrivalTimeError:
                                      state.maxArrivalTime == null,
                                ));

                                // Proceed only if all fields are valid.
                                if (state.selectedDate != null &&
                                    state.minPickUpTime != null &&
                                    state.maxPickUpTime != null &&
                                    state.maxArrivalTime != null) {
                                  _validateFields(); // Navigate to the next step.
                                }
                              },
                              text: 'Next',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
