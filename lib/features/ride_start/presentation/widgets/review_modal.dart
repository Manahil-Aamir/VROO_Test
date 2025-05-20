import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vroo_test/features/ride_start/data/models/give_review_model.dart';

import '../../data/models/inride_passenger_model.dart';
import '../../domain/entities/give_review_entity.dart';
import '../bloc/bloc/ridestart_bloc.dart';
import '../bloc/event/ridestart_event.dart';

class MultiPassengerReviewModal extends StatefulWidget {
  final List<InridePassengerModel> passengers;
  final String rideId;
  final String currentUserId; // Assuming you have the current user's ID

  const MultiPassengerReviewModal({
    super.key,
    required this.passengers,
    required this.rideId,
    required this.currentUserId,
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
      return const Center(child: Text('No passengers to review'));
    }

    final currentPassenger = passengersToReview[currentPassengerIndex];
    final isLastPassenger =
        currentPassengerIndex == passengersToReview.length - 1;

    return AlertDialog(
      title: Text('Review ${currentPassenger.riderName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How was your ride with this passenger?'),
          const SizedBox(height: 16),
          // Star rating widget
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  selectedRating != null && index < selectedRating!
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          // Optional review text
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              labelText: 'Optional review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        if (currentPassengerIndex > 0)
          TextButton(
            onPressed: () {
              setState(() {
                currentPassengerIndex--;
                _resetForm();
              });
            },
            child: const Text('Back'),
          ),
        TextButton(
          onPressed: () async {
            if (selectedRating == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a rating')),
              );
              return;
            }

            // Submit review
            await _submitReview(currentPassenger);

            if (isLastPassenger) {
              Navigator.of(context).pop(); // Close modal when done
            } else {
              setState(() {
                currentPassengerIndex++;
                _resetForm();
              });
            }
          },
          child: Text(isLastPassenger ? 'Done' : 'Next'),
        ),
      ],
    );
  }

  void _resetForm() {
    selectedRating = null;
    reviewController.clear();
  }

  Future<void> _submitReview(InridePassengerModel passenger) async {
    final reviewModel = GiveReviewModel(
      uid: widget.currentUserId,
      receiverUid: passenger.riderId,
      rideId: widget.rideId,
      star: selectedRating!,
      review: reviewController.text.isNotEmpty ? reviewController.text : null,
    );

    // Dispatch the review event to your bloc
    context.read<RideStartBloc>().add(
          SubmitReviewEvent(reviewModel),
        );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
