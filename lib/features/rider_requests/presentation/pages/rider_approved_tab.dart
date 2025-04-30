import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../bloc/bloc/rider_approved_requests_bloc.dart';
import '../bloc/events/rider_approved_requests_event.dart';
import '../bloc/states/rider_approved_requests_state.dart';
import '../widget/rider_approved_card.dart';

class RiderApprovedTab extends StatelessWidget {
  const RiderApprovedTab({super.key});

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
              insetPadding: EdgeInsets.zero, 
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
      context.read<RiderApprovedRequestBloc>().add(FilterApprovedRequestsByDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateFilter(context),
        Expanded(
          child: BlocBuilder<RiderApprovedRequestBloc, RiderApprovedRequestState>(
            builder: (context, state) {
              if (state is RiderApprovedRequestLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RiderApprovedRequestError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(state.message),
                    ],
                  ),
                );
              } else if (state is RiderApprovedRequestLoaded) {
                if (state.filteredRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.selectedDate != null
                            ? 'No approved requests found for this date'
                            : 'No approved requests found',
                        ),
                        if (state.selectedDate != null)
                          TextButton(
                            onPressed: () {
                              context.read<RiderApprovedRequestBloc>().add(ClearApprovedDateFilter());
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
                  itemCount: state.filteredRequests.length,
                  itemBuilder: (context, index) => ApprovedRequestCard(
                    request: state.filteredRequests[index],
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
    return BlocBuilder<RiderApprovedRequestBloc, RiderApprovedRequestState>(
      buildWhen: (previous, current) {
        // Ensure rebuild when the state changes, especially when selectedDate changes
        if (previous is RiderApprovedRequestLoaded && current is RiderApprovedRequestLoaded) {
          return previous.selectedDate != current.selectedDate;
        }
        return true;
      },
      builder: (context, state) {
        // Use null as default value for selectedDate
        DateTime? selectedDate;
        
        // Only extract selectedDate if we're in the correct state
        if (state is RiderApprovedRequestLoaded) {
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
                        
                        if (selectedDate != null)
                          GestureDetector(
                            onTap: () {
                              context.read<RiderApprovedRequestBloc>().add(
                                ClearApprovedDateFilter(),
                              );
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
