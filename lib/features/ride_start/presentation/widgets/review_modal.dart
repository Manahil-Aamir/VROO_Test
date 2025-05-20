import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/ride_start/data/models/give_review_model.dart';
import 'package:vroo_test/features/ride_start/presentation/bloc/state/ridestart_state.dart';

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
    // Filter passengers who haven't been reviewed yet (if needed)
    passengersToReview =
        widget.passengers.where((p) => p.review == null).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (passengersToReview.isEmpty) {
      return AlertDialog(
        title: const Text('All Reviews Complete'),
        content: const Text('All passengers have been reviewed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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
          setState(() {
            isSubmitting = false;
          });

          // Move to next passenger or close if last
          if (isLastPassenger) {
            Navigator.of(context).pop(); // Close modal when done

            // Navigate to home screen if this was intended
            // Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          } else {
            setState(() {
              currentPassengerIndex++;
              _resetForm();
            });
          }
        } else if (state is ReviewFailure) {
          setState(() {
            isSubmitting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review failed: ${state.errorMessage}')),
          );
        }
      },
      child: AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            'Review ${currentPassenger.riderName}',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        content: isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: 300.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'How was your ride with this passenger?',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    // Star rating widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            selectedRating != null && index < selectedRating!
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.yellow,
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
                      controller: reviewController,
                      decoration: InputDecoration(
                        labelText: 'Review',
                        labelStyle: TextStyle(fontSize: 14.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 12.w,
                        ),
                      ),
                      maxLines: 3,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        actions: isSubmitting
            ? []
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
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    if (selectedRating == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please select a rating',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      );
                      return;
                    }

                    // Submit review
                    _submitReview(currentPassenger);
                  },
                  child: Text(
                    isLastPassenger ? 'Done' : 'Next',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
      ),
    );
  }

  void _resetForm() {
    selectedRating = null;
    reviewController.clear();
  }

  void _submitReview(InridePassengerModel passenger) {
    // Set submitting state
    setState(() {
      isSubmitting = true;
    });

    final reviewModel = GiveReviewModel(
      uid: widget.currentUserId,
      receiverUid: passenger.riderId,
      rideId: widget.rideId,
      star: selectedRating!,
      review: reviewController.text.isNotEmpty ? reviewController.text : null,
    );

    // Dispatch the event - BlocListener will handle the response
    widget.rideStartBloc.add(SubmitReviewEvent(reviewModel));
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
