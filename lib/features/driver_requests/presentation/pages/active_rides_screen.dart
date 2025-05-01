import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/appbar_no_icon.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/active_rides_bloc.dart';
import '../bloc/event/active_rides_event.dart';
import '../bloc/state/active_rides_state.dart';
import '../../../../core/theme/color/color_theme.dart';
import 'widgets/active_ride_card.dart';

class ActiveRidesDriverScreen extends StatefulWidget {
  final String id;
  const ActiveRidesDriverScreen({super.key, required this.id});

  @override
  State<ActiveRidesDriverScreen> createState() =>
      _ActiveRidesDriverScreenState();
}

class _ActiveRidesDriverScreenState extends State<ActiveRidesDriverScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ActiveRidesDriverBloc>().add(FetchActiveRidesDriver());
    _initilizeActiveRidesScreen();
  }

  Future<void> _initilizeActiveRidesScreen() async {
    // Check for ongoing trips
    context.read<ActiveRidesDriverBloc>().add(FetchActiveRidesDriver());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('api called: $state');
    // When app comes to foreground, check for ongoing trips
    if (state == AppLifecycleState.resumed) {
      context.read<ActiveRidesDriverBloc>().add(FetchActiveRidesDriver());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be called every time the screen becomes visible again
    context.read<ActiveRidesDriverBloc>().add(FetchActiveRidesDriver());
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
      context.read<ActiveRidesDriverBloc>().add(FilterRidesByDate(picked));
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
      child: BlocListener<ActiveRidesDriverBloc, ActiveRidesDriverState>(
        listener: (context, state) {
          if (state is ActiveRidesDriverLoaded) {
            // Show error snackbar if there's an error message
            if (state.errorMessage != null) {
              _showSnackBar(context, state.errorMessage!, isError: true);
              // Clear the error message to prevent showing it multiple times
              context.read<ActiveRidesDriverBloc>().add(ClearErrorEvent());
            }

            // Show success snackbar if there's a success message
            if (state.successMessage != null) {
              _showSnackBar(context, state.successMessage!, isError: false);
              // Clear the success message to prevent showing it multiple times
              context.read<ActiveRidesDriverBloc>().add(ClearErrorEvent());
            }
          }
          if (state is ActiveRideDataLoaded) {
            print('Ride data loaded: ${state.rideData}');
            // Navigate to ride details page
            context.read<Navigation>().navigateTo(
              '/static_page',
              arguments: {
                'rideData': state.rideData,
              },
            );
          }
        },
        child: Scaffold(
          appBar: AppBarNoIcon(heading: 'Your Rides'),
          body: Column(
            children: [
              // Date filter section
              _buildDateFilter(),
              // Rides list
              Expanded(
                child:
                    BlocBuilder<ActiveRidesDriverBloc, ActiveRidesDriverState>(
                  builder: (context, state) {
                    if (state is ActiveRidesDriverLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActiveRidesDriverError) {
                      return Center(child: Text(state.message));
                    } else if (state is ActiveRidesDriverLoaded) {
                      if (state.filteredRides.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.selectedDate != null
                                    ? 'No rides found for this date'
                                    : 'Please create a ride',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              if (state.selectedDate != null)
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<ActiveRidesDriverBloc>()
                                        .add(ClearDateFilter());
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
      ),
    );
  }

  // Add this method to show snackbars
  void _showSnackBar(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: ThemeColors.buttonTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? Colors.red // Red background for errors
            : Colors.green, // Green background for success
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 70.h, // Positioning above bottom nav bar
          left: 16.w,
          right: 16.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return BlocBuilder<ActiveRidesDriverBloc, ActiveRidesDriverState>(
      builder: (context, state) {
        final selectedDate =
            state is ActiveRidesDriverLoaded ? state.selectedDate : null;

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                                  : ThemeColors.buttonTextColor
                                      .withOpacity(0.7),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              selectedDate != null
                                  ? DateFormat('EEE, dd MMM yyyy')
                                      .format(selectedDate)
                                  : 'Filter by date',
                              style: TextStyle(
                                color: selectedDate != null
                                    ? ThemeColors.buttonTextColor
                                    : ThemeColors.buttonTextColor
                                        .withOpacity(0.7),
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
                              context
                                  .read<ActiveRidesDriverBloc>()
                                  .add(ClearDateFilter());
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color:
                                    ThemeColors.primaryColor.withOpacity(0.15),
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
