import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/appbar.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/active_rides_bloc.dart';
import '../bloc/event/active_rides_event.dart';
import '../bloc/state/active_rides_state.dart';
import '../../../../core/theme/color/color_theme.dart';
import 'widgets/active_ride_card.dart';

class ActiveRidesScreen extends StatefulWidget {
  final String id;
  const ActiveRidesScreen({super.key, required this.id});

  @override
  State<ActiveRidesScreen> createState() => _ActiveRidesScreenState();
}

class _ActiveRidesScreenState extends State<ActiveRidesScreen> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    context.read<ActiveRidesBloc>().add(FetchActiveRides(user!.uid));
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ThemeColors.primaryColor,
              onPrimary: ThemeColors.buttonTextColor,
              // onSurface: ThemeColors.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      context.read<ActiveRidesBloc>().add(FilterRidesByDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          SystemNavigator.pop(); // Closes the app
        }
        return false; // Prevents the default back action
      },
      child: Scaffold(
        appBar: AppBarNoIcon(heading: 'Your Rides'),
        body: Column(
        children: [
          // Date filter section
          _buildDateFilter(),
          // Rides list
          Expanded(
            child: BlocBuilder<ActiveRidesBloc, ActiveRidesState>(
                builder: (context, state) {
                  if (state is ActiveRidesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ActiveRidesError) {
                    return Center(child: Text(state.message));
                  } else if (state is ActiveRidesLoaded) {
                    if (state.filteredRides.isEmpty) {
                      return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(
                              state.selectedDate != null
                                ? 'No rides found for this date'
                                : 'Please create a ride',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          if (state.selectedDate != null)
                            TextButton(
                              onPressed: () {
                                context.read<ActiveRidesBloc>().add(ClearDateFilter());
                              },
                              child: Text(
                                'Show all rides',
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
                      itemCount: state.filteredRides.length,
                      itemBuilder: (context, index) => ActiveRideCard(
                        ride: state.filteredRides[index],
                      ),
                    );
                  }
                  return const Center(child: Text('Fetching rides...'));
                },
              ),
          ),
        ],
      ),
        bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return BlocBuilder<ActiveRidesBloc, ActiveRidesState>(
      builder: (context, state) {
        final selectedDate = state is ActiveRidesLoaded ? state.selectedDate : null;
        
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
                              context.read<ActiveRidesBloc>().add(ClearDateFilter());
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

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Exit App",
            message: "Are you sure you want to exit?",
            confirmText: "Yes",
            cancelText: "No",
            confirmColor: Theme.of(context).indicatorColor,
            cancelColor: Theme.of(context).primaryColorDark,
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
            onCancel: () {
              Navigator.of(context).pop(false);
            },
          ),
        ) ??
        false;
  }
}
