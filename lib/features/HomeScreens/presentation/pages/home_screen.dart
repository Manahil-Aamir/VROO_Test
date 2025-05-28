import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/features/HomeScreens/data/data_source/coords_data_source.dart';
import '../../../../core/router/navigation.dart';
import '../../../../core/utils/exit_dialouge_util.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
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
  CoordsDataSource coordsDataSource = CoordsDataSource();

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
    print('api called: $state');
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
        bool exitApp = await DialogUtil.showExitDialog(context);
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
    final theme = Theme.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            current is OngoingTripLoaded ||
            current is OngoingTripLoading ||
            current is NoOngoingTripState ||
            current is OngoingTripError,
        builder: (context, state) {
          if (state is OngoingTripLoaded && state.trip.rideId != 'sample_id') {
            print('home screen ongoing trip: ${state.trip.rideId}');
            // Display ongoing trip notification at the top with light green background
            return Positioned(
              top: 110.h, // Position below the top bar
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  // Navigate to trip details or show more details
                  print('Ongoing trip clicked: ${state.trip.rideId}');
                  print(state.trip.mode.toString() == 'Driver');
                  if (state.trip.mode == 'Driver') {
                    context
                        .read<Navigation>()
                        .navigateTo('/ride_tracking', arguments: {
                      'rideId': state.trip.rideId,
                      'coords': await coordsDataSource
                          .fetchRouteCoordinates(state.trip.rideId),
                    });
                  } else if (state.trip.mode == 'Rider') {
                    context
                        .read<Navigation>()
                        .navigateTo('/rider_view', arguments: {
                      'rideId': state.trip.rideId,
                      'coords': await coordsDataSource
                          .fetchRouteCoordinates(state.trip.rideId),
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.secondaryHeaderColor
                        .withOpacity(0.3), // Light green background
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
                        color: theme.primaryColor, // Dark green icon
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have ongoing ride as ${state.trip.mode}: ${state.trip.rideId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: theme.primaryColorDark, // Dark green icon
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            print(state.runtimeType);
          }

          // Don't show anything if there's no ongoing trip or it's a sample
          return const SizedBox.shrink();
        });
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
