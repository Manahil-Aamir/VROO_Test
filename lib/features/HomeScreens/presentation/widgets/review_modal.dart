import 'package:flutter/material.dart';
import 'package:vroo_test/features/HomeScreens/data/models/ride_check_model.dart';

import '../../../../shared/widgets/dialog_button.dart';

class ReviewModal extends StatefulWidget {
  final RideCheckModel rideData;
  final Function(int stars, String review) onSubmitReview;

  const ReviewModal({
    super.key,
    required this.rideData,
    required this.onSubmitReview,
  });

  @override
  State<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  int? _selectedStars;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;
  bool showRatingError = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_selectedStars == null) {
      setState(() {
        showRatingError = true;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      showRatingError = false;
    });

    try {
      // Call the callback function passed from parent
      await widget.onSubmitReview(
          _selectedStars!, _reviewController.text.trim());
    } catch (e) {
      // Handle error if submission fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {}, // disables tap outside to dismiss
        child: AlertDialog(
          backgroundColor: theme.primaryColorDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            children: [
              Text(
                'Rate Your Driver',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.rideData.driverNameFromUser.isNotEmpty
                    ? widget.rideData.driverNameFromUser
                    : 'Driver',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          content: _isSubmitting
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
                        SizedBox(height: 16),
                        Text(
                          'Submitting review...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.canvasColor,
                          ),
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
                      SizedBox(height: 5),
                      // Star rating widget
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final isSelected =
                              _selectedStars != null && index < _selectedStars!;
                          return Container(
                            child: IconButton(
                              icon: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: isSelected
                                    ? Colors.amberAccent
                                    : theme.primaryColorLight,
                                size: 36,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedStars = index + 1;
                                  showRatingError =
                                      false; // Hide error on select
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      if (showRatingError) // Show only if flag is true
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Rating is required',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.indicatorColor,
                            ),
                          ),
                        ),
                      SizedBox(height: 8),
                      // Optional review text
                      TextField(
                        cursorColor: theme.primaryColor,
                        controller: _reviewController,
                        decoration: InputDecoration(
                          labelText: 'Give a review (optional)',
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
                            borderRadius: BorderRadius.circular(12),
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
          actions: _isSubmitting
              ? null
              : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DialogButton(
                        onTap: () {
                          if (_selectedStars == null) {
                            setState(() {
                              showRatingError = true;
                            });
                            return;
                          }
                          setState(() {
                            showRatingError = false;
                          });
                          _submitReview();
                        },
                        text: 'Done',
                        color: theme.primaryColor,
                      ),
                    ],
                  )
                ],
        ),
      ),
    );
  }
}
