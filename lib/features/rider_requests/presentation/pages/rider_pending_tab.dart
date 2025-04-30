import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/rider_pending_request_entity.dart';
import '../bloc/bloc/rider_pending_requests_bloc.dart';
import '../bloc/events/rider_pending_requests_event.dart';
import '../bloc/states/rider_pending_requests_state.dart';
import '../widget/rider_pending_card.dart';

class RiderPendingTab extends StatelessWidget {
  const RiderPendingTab({super.key});

  Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? today,
      firstDate: today, 
      lastDate: DateTime(2100),
      cancelText: '', 
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primaryColor,
              onPrimary: ThemeColors.buttonTextColor,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none, 
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: child!,
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(Icons.close, size: 24),
                  color: ThemeColors.primaryColor,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      context.read<RiderPendingRequestBloc>().add(FilterPendingRequestsByDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateFilter(context),
        Expanded(
          child: BlocConsumer<RiderPendingRequestBloc, RiderPendingRequestState>(
            listener: (context, state) {
              if (state is RiderPendingRequestDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              List<RiderPendingRequest> requests = [];
              DateTime? selectedDate;
              
              if (state is RiderPendingRequestLoaded) {
                requests = state.filteredRequests;
                selectedDate = state.selectedDate;
              } else if (state is RiderPendingRequestDeleted) {
                requests = state.remainingFilteredRequests;
                selectedDate = state.selectedDate;
              }

              if (state is RiderPendingRequestLoading && 
                  !(state is RiderPendingRequestLoaded || state is RiderPendingRequestDeleted)) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RiderPendingRequestError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(state.message),
                    ],
                  ),
                );
              } else if (state is RiderPendingRequestLoaded || 
                        state is RiderPendingRequestDeleted) {
                if (requests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedDate != null
                            ? 'No pending requests found for this date'
                            : 'No pending requests found',
                        ),
                        if (selectedDate != null)
                          TextButton(
                            onPressed: () {
                              context.read<RiderPendingRequestBloc>().add(ClearPendingDateFilter());
                            },
                            child: Text(
                              'Show all requests',
                              style: TextStyle(
                                color: ThemeColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) => PendingRequestCard(
                    request: requests[index],
                  ),
                );
              }
              return const Center(child: Text('Select tab to load requests'));
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateFilter(BuildContext context) {
    return BlocBuilder<RiderPendingRequestBloc, RiderPendingRequestState>(
      buildWhen: (previous, current) {
        // Ensure rebuild when the selectedDate changes
        if (previous is RiderPendingRequestLoaded && current is RiderPendingRequestLoaded) {
          return previous.selectedDate != current.selectedDate;
        }
        if (previous is RiderPendingRequestDeleted && current is RiderPendingRequestLoaded) {
          return previous.selectedDate != current.selectedDate;
        }
        if (previous is RiderPendingRequestLoaded && current is RiderPendingRequestDeleted) {
          return previous.selectedDate != current.selectedDate;
        }
        return true;
      },
      builder: (context, state) {
        // Initialize with null
        DateTime? selectedDate;
        
        // Extract selectedDate depending on the state type
        if (state is RiderPendingRequestLoaded) {
          selectedDate = state.selectedDate;
        } else if (state is RiderPendingRequestDeleted) {
          selectedDate = state.selectedDate;
        }
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Date selector chip
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, selectedDate),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ThemeColors.primaryColorDark,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selectedDate != null 
                            ? ThemeColors.primaryColor 
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 20.r,
                              color: selectedDate != null
                                  ? ThemeColors.primaryColor
                                  : ThemeColors.buttonTextColor.withOpacity(0.7),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              selectedDate != null
                                  ? DateFormat('EEE, dd MMM yyyy').format(selectedDate)
                                  : 'Filter by date',
                              style: TextStyle(
                                color: selectedDate != null
                                    ? ThemeColors.buttonTextColor
                                    : ThemeColors.buttonTextColor.withOpacity(0.7),
                                fontSize: 14.sp,
                                fontWeight: selectedDate != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        
                        // Clear button or dropdown indicator
                        if (selectedDate != null)
                          GestureDetector(
                            onTap: () {
                              context.read<RiderPendingRequestBloc>().add(ClearPendingDateFilter());
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: ThemeColors.primaryColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16.r,
                                color: ThemeColors.primaryColor,
                              ),
                            ),
                          )
                        else
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20.r,
                            color: ThemeColors.buttonTextColor.withOpacity(0.5),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
