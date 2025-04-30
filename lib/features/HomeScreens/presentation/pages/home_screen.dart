import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/navigation.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/custom_dialog.dart';
import '../bloc/bloc/home_bloc.dart';
import '../bloc/event/home_event.dart';
import '../bloc/state/home_state.dart';
import '../widgets/location_selection_button_widget.dart';
import '../widgets/side_bar_widget.dart';
import '../widgets/top_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeHomeScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app comes to foreground, check for ongoing trips
    if (state == AppLifecycleState.resumed) {
      context.read<HomeBloc>().add(CheckOngoingTripEvent());
    }
  }

  Future<void> _initializeHomeScreen() async {
    // Load user data first
    context.read<HomeBloc>().add(LoadUserEvent());

    // Check for ongoing trips
    context.read<HomeBloc>().add(CheckOngoingTripEvent());
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
        key: _scaffoldKey,
        drawer: const SidebarWidget(),
        body: Stack(
          children: [
            _buildMapContent(),
            TopBarWidget(scaffoldKey: _scaffoldKey),
            const LocationSelectionButtonsWidget(),
            _buildOngoingTripOverlay(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: 0,
        ),
      ),
    );
  }

  Widget _buildMapContent() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLogoutSuccess) {
          context.read<Navigation>().navigateTo('/sign_in');
        } else if (state is OngoingTripError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        print('HomeState: $state');
        return const NativeGoogleMap();
      },
    );
  }

  Widget _buildOngoingTripOverlay() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          current is OngoingTripLoaded ||
          current is OngoingTripLoading ||
          current is NoOngoingTripState ||
          current is OngoingTripError,
      builder: (context, state) {
        if (state is OngoingTripLoaded && state.trip.rideId != 'sample_id') {
          // Display ongoing trip notification at the top with light green background
          return Positioned(
            top: 80, // Position below the top bar
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Navigate to trip details or show more details
                print('Ongoing trip clicked: ${state.trip.rideId}');
                // Example: context.read<Navigation>().navigateTo('/ongoing_trip_details/${state.trip.rideId}');
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green[100], // Light green background
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: Colors.green[800], // Dark green icon
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You have ongoing ride: ${state.trip.rideId} as ${state.trip.role}',
                        style: TextStyle(
                          color: Colors.green[800], // Dark green text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.green[800], // Dark green icon
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Don't show anything if there's no ongoing trip or it's a sample
        return const SizedBox.shrink();
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

class NativeGoogleMap extends StatelessWidget {
  const NativeGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'native_google_map',
      layoutDirection: TextDirection.ltr,
      creationParams: {
        'showMarkersByDefault': false, // Explicitly disable markers
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
