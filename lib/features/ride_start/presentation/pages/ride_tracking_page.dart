import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vroo_test/features/ride_start/data/models/ridestart_data_model.dart';
import 'package:vroo_test/features/ride_start/presentation/pages/nopassenger.dart';
import 'package:vroo_test/features/ride_start/presentation/pages/tracking_modal.dart';
import '../../../../core/router/navigation.dart';
import '../../data/data_source/driver_tracker.dart';
import '../bloc/bloc/ridestart_bloc.dart';
import '../bloc/event/ridestart_event.dart';
import '../bloc/state/ridestart_state.dart';
import '../widgets/review_modal.dart';

class LocationServiceMonitor {
  final VoidCallback onEnabled;
  bool _lastStatus = false;
  Timer? _checkTimer;

  LocationServiceMonitor({required this.onEnabled});

  Future<void> startMonitoring() async {
    _lastStatus = await Geolocator.isLocationServiceEnabled();
    _checkTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final currentStatus = await Geolocator.isLocationServiceEnabled();
      if (currentStatus && !_lastStatus) {
        onEnabled();
      }
      _lastStatus = currentStatus;
    });
  }

  void stopMonitoring() {
    _checkTimer?.cancel();
  }
}

class RideTrackingScreen extends StatefulWidget {
  final String rideId;
  final List<List<double>>? coords;

  const RideTrackingScreen({super.key, required this.rideId, this.coords});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with WidgetsBindingObserver {
  late RealTimeRideTracker _rideTracker;
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');
  late LocationServiceMonitor _locationMonitor;

  bool _isMapReady = false;
  bool _isTracking = false;
  bool _isLoading = true;
  String? _errorMessage;
  int? _mapViewId;
  RidestartDataModel? _rideData;
  bool _isRideTrackerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locationMonitor = LocationServiceMonitor(
      onEnabled: _resumeTrackingAutomatically,
    );
    _locationMonitor.startMonitoring();

    // Initialize ride by triggering the bloc event with ride ID
    context.read<RideStartBloc>().add(InitializeRideEvent(widget.rideId));
  }

  @override
  void dispose() {
    _locationMonitor.stopMonitoring();
    WidgetsBinding.instance.removeObserver(this);
    if (_isRideTrackerInitialized) {
      _rideTracker.dispose();
    }
    super.dispose();
  }

  Future<void> _resumeTrackingAutomatically() async {
    final theme = Theme.of(context);
    if (!_isTracking &&
        mounted &&
        _rideData != null &&
        _isRideTrackerInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location enabled - resuming tracking'),
          backgroundColor: theme.secondaryHeaderColor,
          duration: Duration(seconds: 2),
        ),
      );
      await _toggleTracking();
    }
  }

  Future<void> _initializeApp(RidestartDataModel rideData) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _rideData = rideData;
      });

      _rideTracker = RealTimeRideTracker(rideId: rideData.id);
      await _rideTracker.initialize();
      await _rideTracker.loadHistoricalRouteData();

      setState(() {
        _isRideTrackerInitialized = true;
        _isLoading = false;
      });

      // Start tracking automatically after initialization
      if (mounted) {
        _toggleTracking();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _initializeMap(int viewId) async {
    if (_rideData == null) {
      setState(() {
        _errorMessage = 'Cannot initialize map: Ride data is not available';
      });
      return;
    }

    try {
      final passengers = _rideData!.passengers.map((passenger) {
        final p = passenger;
        return {
          'id': p.riderId,
          'name': p.riderName,
          'pickupLat': p.rideRequest.source.coords[0],
          'pickupLng': p.rideRequest.source.coords[1],
          'dropoffLat': p.rideRequest.destination.coords[0],
          'dropoffLng': p.rideRequest.destination.coords[1],
          'sameSource': p.rideRequest.matches.any((m) => m.sameSource),
        };
      }).toList();

      await _mapChannel.invokeMethod('initializeMap', {
        'viewId': viewId,
        'source': {
          'lat': _rideData!.source.coords[0],
          'lng': _rideData!.source.coords[1],
        },
        'destination': {
          'lat': _rideData!.destination.coords[0],
          'lng': _rideData!.destination.coords[1],
        },
        'routeCoords': widget.coords ?? [],
        'passengers': passengers,
      });

      if (widget.coords != null) {
        print('Route coordinates from home screen: ${widget.coords}');
      }

      await _mapChannel.invokeMethod('fitRouteToScreen', {'viewId': viewId});
      setState(() => _isMapReady = true);
    } catch (e) {
      setState(() {
        _errorMessage = 'Map initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _handleLocationPermissions() async {
    final theme = Theme.of(context);
    final servicesEnabled = await Geolocator.isLocationServiceEnabled();

    if (!servicesEnabled) {
      // Show snackbar and open location services settings
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening location services settings...'),
            backgroundColor: theme.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Open location services settings
      await Geolocator.openLocationSettings();
      return;
    }

    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final requestResult = await Geolocator.requestPermission();

      if (requestResult == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permission denied'),
              backgroundColor: theme.indicatorColor,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      if (requestResult == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening app settings for location permission...'),
              backgroundColor: theme.primaryColor,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Open app settings for location permission
        await Geolocator.openAppSettings();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening app settings for location permission...'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Open app settings for location permission
      await Geolocator.openAppSettings();
      return;
    }

    // If we reach here, location services are enabled and permission is granted
    // Proceed with starting tracking
    await _startTracking();
  }

  Future<void> _startTracking() async {
    final theme = Theme.of(context);
    if (_rideData == null || !_isRideTrackerInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot start tracking: Ride tracker not initialized'),
          backgroundColor: theme.indicatorColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isTracking = true);
    try {
      await _rideTracker.startTracking();
    } catch (e) {
      setState(() => _isTracking = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tracking error: ${e.toString()}'),
            backgroundColor: theme.indicatorColor,
          ),
        );
      }
    }
  }

  Future<void> _toggleTracking() async {
    final theme = Theme.of(context);
    if (_rideData == null || !_isRideTrackerInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot toggle tracking: Ride tracker not initialized'),
          backgroundColor: theme.indicatorColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_isTracking) {
      // Stop tracking
      setState(() => _isTracking = false);
      try {
        await _rideTracker.stopTracking();
      } catch (e) {
        setState(() => _isTracking = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error stopping tracking: ${e.toString()}'),
              backgroundColor: theme.indicatorColor,
            ),
          );
        }
      }
    } else {
      // Start tracking - handle permissions first
      await _handleLocationPermissions();
    }
  }

  Future<void> _endRide() async {
    final theme = Theme.of(context);
    if (!_isRideTrackerInitialized) return;

    try {
      // Stop tracking first
      await _rideTracker.stopTracking();
      if (!mounted) return;
      print('Tracking stopped successfully');

      // Get the RideStartBloc before making API calls
      final rideStartBloc = BlocProvider.of<RideStartBloc>(context);

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call end ride API
      rideStartBloc.add(EndRideEvent());

      // Listen for the end ride response
      final subscription = rideStartBloc.stream.listen((state) {
        if (state is EndRideSuccess) {
          // Dismiss loading dialog
          if (mounted) Navigator.of(context).pop();

          // Extract CO₂ savings from response
          final totalCo2Saved = state.endRideData['data']['totalCo2Saved'];

          // Show CO₂ savings snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '🌱 Great job! You saved $totalCo2Saved kg of CO₂ emissions!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: theme.secondaryHeaderColor,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              showDialog(
                context: context,
                builder: (dialogContext) => MultiPassengerReviewModal(
                  passengers: _rideData!.passengers,
                  rideId: _rideData!.id,
                  currentUserId: _rideData!.driverId,
                  rideStartBloc: rideStartBloc,
                ),
              );
            }
          });
          context.read<Navigation>().navigateTo('/home');

          print('Ride ended successfully: ${_rideData!.id}');
          print('CO₂ saved: $totalCo2Saved kg');
        } else if (state is EndRideFailure) {
          // Dismiss loading dialog
          if (mounted) Navigator.of(context).pop();

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to end ride: ${state.errorMessage}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      });

      //Clean up subscription after 10 seconds to prevent memory leaks
      Timer(const Duration(seconds: 10), () {
        subscription.cancel();
      });
    } catch (e) {
      // Dismiss loading dialog if it's showing
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to end ride: ${e.toString()}'),
          backgroundColor: theme.indicatorColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<Navigation>().navigateTo('/home');
        return false;
      },
      child: BlocConsumer<RideStartBloc, RideStartState>(
        listener: (context, state) {
          if (state is RideStartSuccess) {
            print('Ride started successfully: ${state.rideData}');
            _initializeApp(state.rideData);
          } else if (state is RideStartFailure) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.errorMessage;
            });
          }
        },
        builder: (context, state) {
          final theme = Theme.of(context);

          return Scaffold(
            body: Stack(
              children: [
                _buildContent(state),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon:
                                Icon(Icons.home, color: theme.primaryColorDark),
                            onPressed: () {
                              context.read<Navigation>().navigateTo('/home');
                            },
                          ),
                          if (_isMapReady && _mapViewId != null)
                            IconButton(
                              icon: Icon(Icons.refresh,
                                  color: theme.primaryColorDark),
                              onPressed: () => _mapChannel.invokeMethod(
                                  'fitRouteToScreen', {'viewId': _mapViewId}),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_rideData != null &&
                    _isRideTrackerInitialized &&
                    !_isLoading)
                  Positioned(
                    top: 30.h + MediaQuery.of(context).padding.top,
                    left: 75.w,
                    right: 75.w,
                    child: SizedBox(
                      width: 50.w,
                      child: ElevatedButton.icon(
                        onPressed: _isTracking ? _endRide : _toggleTracking,
                        icon: _isTracking
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.play_arrow),
                        label: Text(_isTracking ? 'End Ride' : 'Resume Ride'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isTracking
                              ? theme.secondaryHeaderColor
                              : theme.indicatorColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (_isTracking && _rideData != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TrackingRideDetailsBottomSheet(
                      rideData: _rideData!,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(RideStartState state) {
    if (state is RideStartLoading || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RideStartFailure || _errorMessage != null) {
      final errorMessage = _errorMessage ??
          (state is RideStartFailure ? state.errorMessage : '');

      if (errorMessage.contains('Ride cannot be started without a passenger')) {
        // Set loading to false to prevent circular progress indicator
        if (_isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }

        // Show modal
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showNoPassengerModal(context);
        });
      } else {
        // Handle other errors normally
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    }

    // Always show the main screen if ride data is available or not
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _buildMapView(),
              if (_isMapReady) _buildMapControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapView() {
    if (_rideData == null) return const SizedBox.shrink();

    return AndroidView(
      viewType: 'ride_tracking_map',
      creationParams: <String, dynamic>{
        'initialLat': _rideData!.source.coords[0],
        'initialLng': _rideData!.source.coords[1],
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        _mapViewId = id;
        _initializeMap(id);
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 150.h,
      right: 16,
      child: Column(
        children: [
          _buildMapButton(
            Icons.add,
            () => _mapViewId != null
                ? _mapChannel.invokeMethod('zoomIn', {'viewId': _mapViewId})
                : null,
          ),
          const SizedBox(height: 8),
          _buildMapButton(
            Icons.remove,
            () => _mapViewId != null
                ? _mapChannel.invokeMethod('zoomOut', {'viewId': _mapViewId})
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, VoidCallback? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        disabledColor: Colors.grey,
      ),
    );
  }

  void showNoPassengerModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return const NoPassengerModal();
      },
    );
  }
}
