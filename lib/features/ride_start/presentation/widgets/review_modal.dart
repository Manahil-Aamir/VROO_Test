import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/ride_start/data/models/give_review_model.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/state/ridestart_state.dart';
import 'package:vroo_test/shared/widgets/dialog_button.dart';

import '../../data/models/inride_passenger_model.dart';
import '../../domain/entities/give_review_entity.dart';
import '../bloc/bloc/ridestart_bloc.dart';
import '../bloc/event/ridestart_event.dart';

class MultiPassengerReviewModal extends StatefulWidget {
  final List<InridePassengerModel> passengers;
  final String rideId;
  final String currentUserId;
  final RideStartBloc rideStartBloc;

  const MultiPassengerReviewModal({
    super.key,
    required this.passengers,
    required this.rideId,
    required this.currentUserId,
    required this.rideStartBloc,
  });

  @override
  State<MultiPassengerReviewModal> createState() =>
      _MultiPassengerReviewModalState();
}

class _MultiPassengerReviewModalState extends State<MultiPassengerReviewModal> {
  late List<InridePassengerModel> passengersToReview;
  int currentPassengerIndex = 0;
  int? selectedRating;
  TextEditingController reviewController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    passengersToReview =
        widget.passengers.where((p) => p.review == null).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (passengersToReview.isEmpty) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('All Reviews Complete', style: theme.textTheme.titleLarge),
        content: Text('All passengers have been reviewed.',
            style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: theme.textTheme.labelLarge),
          ),
        ],
      );
    }

    final currentPassenger = passengersToReview[currentPassengerIndex];
    final isLastPassenger =
        currentPassengerIndex == passengersToReview.length - 1;

    return BlocListener<RideStartBloc, RideStartState>(
      bloc: widget.rideStartBloc,
      listener: (context, state) {
        if (state is ReviewSuccess) {
          setState(() => isSubmitting = false);

          if (isLastPassenger) {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          } else {
            setState(() {
              currentPassengerIndex++;
              _resetForm();
            });
          }
        } else if (state is ReviewFailure) {
          setState(() => isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review failed: ${state.errorMessage}')),
          );
        }
      },
      child: AlertDialog(
        backgroundColor: theme.primaryColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Text(
              'Rate Your Passenger',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              currentPassenger.riderName,
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
        content: isSubmitting
            ? SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Submitting review...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'How was your experience?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.canvasColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Star rating widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            selectedRating != null && index < selectedRating!
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: selectedRating != null &&
                                    index < selectedRating!
                                ? Colors.yellow
                                : theme.primaryColorLight,
                            size: 36.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),
                    // Optional review text
                    TextField(
                      cursorColor: theme.primaryColor,
                      controller: reviewController,
                      decoration: InputDecoration(
                        labelText: 'Give a review',
                        labelStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColorLight.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: theme.primaryColorLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.canvasColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: theme.primaryColorLight,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 3,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.canvasColor,
                      ),
                    ),
                  ],
                ),
              ),
        actions: isSubmitting
            ? null
            : [
                if (currentPassengerIndex > 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        currentPassengerIndex--;
                        _resetForm();
                      });
                    },
                    child: Text(
                      'Back',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                DialogButton(
                  onTap: () {
                    if (selectedRating == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a rating'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    _submitReview(currentPassenger);
                  },
                  text: isLastPassenger ? 'Done' : 'Next',
                  color: theme.primaryColor,
                )
              ],
      ),
    );
  }

  void _resetForm() {
    selectedRating = null;
    reviewController.clear();
  }

  void _submitReview(InridePassengerModel passenger) {
    setState(() => isSubmitting = true);

    final reviewModel = GiveReviewModel(
      uid: widget.currentUserId,
      receiverUid: passenger.riderId,
      rideId: widget.rideId,
      star: selectedRating!,
      review: reviewController.text.isNotEmpty ? reviewController.text : null,
    );

    widget.rideStartBloc.add(SubmitReviewEvent(reviewModel));
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
