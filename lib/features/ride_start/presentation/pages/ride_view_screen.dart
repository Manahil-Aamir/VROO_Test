// Main RideTrackingScreen
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../HomeScreens/data/data_source/coords_data_source.dart';
import '../../data/models/rider_view_model.dart';
import '../bloc/bloc/ride_view_bloc.dart';
import '../bloc/event/rideview_event.dart';
import '../bloc/state/rideview_state.dart';
import '../widgets/rideview_modal.dart';

class RideViewScreen extends StatefulWidget {
  final String rideId;
  final List<List<double>>? coords;

  const RideViewScreen({super.key, required this.rideId, this.coords});

  @override
  State<RideViewScreen> createState() => _RideViewScreenState();
}

class _RideViewScreenState extends State<RideViewScreen>
    with WidgetsBindingObserver {
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');

  bool _isMapReady = false;
  bool _isLoading = true;
  String? _errorMessage;
  int? _mapViewId;
  RideViewModel? _rideData;

  // For route updates
  late CoordsDataSource _coordsDataSource;
  Timer? _routeUpdateTimer;
  List<List<double>> _currentRouteCoords = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coordsDataSource = CoordsDataSource();

    // Initialize ride by triggering the bloc event with ride ID
    context.read<RideViewBloc>().add(InitializeRideViewEvent(widget.rideId));

    // Set initial coordinates if provided
    if (widget.coords != null) {
      _currentRouteCoords = widget.coords!;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopRouteUpdates();
    super.dispose();
  }

  void _startRouteUpdates() {
    // Cancel any existing timer
    _stopRouteUpdates();

    // Start new timer to fetch route coordinates every 10 seconds
    _routeUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final updatedCoords =
            await _coordsDataSource.fetchRouteCoordinates(widget.rideId);
        if (updatedCoords.isNotEmpty && mounted) {
          // Only update if coordinates have actually changed
          if (!_areCoordinatesEqual(_currentRouteCoords, updatedCoords)) {
            setState(() {
              _currentRouteCoords = updatedCoords;
            });

            print('Updated coords count: ${_currentRouteCoords.length}');

            // Update map with new coordinates AND position vehicle
            _updateMapRoute();
          }
        }
      } catch (e) {
        print('Error updating route coordinates: $e');
      }
    });
  }

  // Utility method to compare two coordinate lists
  bool _areCoordinatesEqual(
      List<List<double>> list1, List<List<double>> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].length != list2[i].length) return false;

      for (int j = 0; j < list1[i].length; j++) {
        if (list1[i][j] != list2[i][j]) return false;
      }
    }
    print('Coordinates are equal');

    return true;
  }

  void _stopRouteUpdates() {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = null;
  }

  Future<void> _updateMapRoute() async {
    if (_mapViewId != null && _isMapReady && _currentRouteCoords.isNotEmpty) {
      try {
        print(
            'Updating map route with ${_currentRouteCoords.length} coordinates');

        // Update route coordinates
        await _mapChannel.invokeMethod('updateRouteCoordinates', {
          'viewId': _mapViewId,
          'routeCoords': _currentRouteCoords,
        });

        // Position vehicle at the last coordinate (most recent position)
        final lastCoord = _currentRouteCoords[_currentRouteCoords.length - 1];

        // Calculate bearing if we have at least 2 points
        double bearing = 0.0;
        if (_currentRouteCoords.length > 1) {
          final secondLastCoord =
              _currentRouteCoords[_currentRouteCoords.length - 2];
          bearing = _calculateBearing(secondLastCoord[0], secondLastCoord[1],
              lastCoord[0], lastCoord[1]);
        }

        // Update vehicle position
        await _mapChannel.invokeMethod('updateVehiclePosition', {
          'lat': lastCoord[0],
          'lng': lastCoord[1],
          'heading': bearing,
        });

        print(
            'Vehicle positioned at: ${lastCoord[0]}, ${lastCoord[1]} with bearing: $bearing');
      } catch (e) {
        print('Error updating map route: $e');
      }
    }
  }

  // Helper method to calculate bearing between two points
  double _calculateBearing(
      double startLat, double startLng, double endLat, double endLng) {
    final startLatRad = startLat * (pi / 180);
    final startLngRad = startLng * (pi / 180);
    final endLatRad = endLat * (pi / 180);
    final endLngRad = endLng * (pi / 180);

    final dLng = endLngRad - startLngRad;

    final y = sin(dLng) * cos(endLatRad);
    final x = cos(startLatRad) * sin(endLatRad) -
        sin(startLatRad) * cos(endLatRad) * cos(dLng);

    double bearing = atan2(y, x) * (180 / pi);

    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  Future<void> _initializeMap(int viewId) async {
    if (_rideData == null) {
      setState(() {
        _errorMessage = 'Cannot initialize map: Ride data is not available';
      });
      return;
    }

    try {
      _mapViewId = viewId;

      // Get coordinates from passenger data
      final sourceCoords = _rideData!.passengerData.source.coords;
      final destCoords = _rideData!.passengerData.destination.coords;

      // Initialize map with ride view data (no passengers for rider view)
      await _mapChannel.invokeMethod('initializeMap', {
        'source': {
          'lat': sourceCoords[0],
          'lng': sourceCoords[1],
        },
        'destination': {
          'lat': destCoords[0],
          'lng': destCoords[1],
        },
        'routeCoords': _currentRouteCoords,
        'passengers': [], // Empty as this is rider view
      });

      print('Source: lat=${sourceCoords[0]}, lng=${sourceCoords[1]}');
      print('Destination: lat=${destCoords[0]}, lng=${destCoords[1]}');
      print('Initial route coords count: ${_currentRouteCoords.length}');

      setState(() {
        _isMapReady = true;
      });

      // Position vehicle at the last coordinate if we have route data
      if (_currentRouteCoords.isNotEmpty) {
        await _updateMapRoute();
      }

      await _fitRouteToScreen();

      // Start regular route updates after map is ready
      _startRouteUpdates();
    } catch (e) {
      setState(() {
        _errorMessage = 'Map initialization failed: ${e.toString()}';
      });
    }
  }

  Future<void> _fitRouteToScreen() async {
    if (_mapViewId != null) {
      await _mapChannel.invokeMethod('fitRouteToScreen');
    }
  }

  Future<void> _zoomMap(String direction) async {
    if (_mapViewId != null) {
      await _mapChannel.invokeMethod(direction == 'in' ? 'zoomIn' : 'zoomOut');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideViewBloc, RideViewState>(
      listener: (context, state) {
        if (state is RideViewSuccess) {
          print('Ride view loaded successfully: ${state.rideData}');
          setState(() {
            _rideData = state.rideData;
            _isLoading = false;

            // Only set route coords if we don't have them yet
            if (_currentRouteCoords.isEmpty && widget.coords != null) {
              _currentRouteCoords = widget.coords!;
            }
          });

          // Initialize map if it's ready but not yet initialized with data
          if (_isMapReady &&
              _mapViewId != null &&
              _currentRouteCoords.isNotEmpty) {
            _updateMapRoute();
          }
        } else if (state is RideViewFailure) {
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
              // Top navigation bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: theme.primaryColorDark),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        if (_isMapReady && _mapViewId != null)
                          IconButton(
                            icon: Icon(Icons.refresh,
                                color: theme.primaryColorDark),
                            onPressed: _fitRouteToScreen,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Driver info modal at bottom
              if (_rideData != null && !_isLoading)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RideDetailsBottomSheet(
                    rideData: _rideData!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(RideViewState state) {
    if (state is RideViewLoading || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RideViewFailure || _errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage ?? (state as RideViewFailure).errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    if (_rideData != null) {
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

    return const Center(child: Text('Waiting for ride data...'));
  }

  Widget _buildMapView() {
    if (_rideData == null) return const SizedBox.shrink();

    // Get source coordinates once
    final sourceCoords = _rideData!.passengerData.source.coords;

    return AndroidView(
      viewType: 'ride_tracking_map',
      creationParams: <String, dynamic>{
        'initialLat': sourceCoords[0],
        'initialLng': sourceCoords[1],
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
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
            () => _zoomMap('in'),
          ),
          const SizedBox(height: 8),
          _buildMapButton(
            Icons.remove,
            () => _zoomMap('out'),
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
}
