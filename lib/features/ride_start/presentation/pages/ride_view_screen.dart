// Main RideTrackingScreen
import 'dart:async';

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
  State<RideViewScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideViewScreen>
    with WidgetsBindingObserver {
  final MethodChannel _mapChannel =
      const MethodChannel('com.example.vroo_test/ride_map');

  bool _isMapReady = false;
  bool _isLoading = true;
  String? _errorMessage;
  int? _mapViewId;
  RideViewModel? _rideData;
  bool _initialMapSetup =
      false; // Flag to track if map has been set up initially

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

            // Print number of coordinates and polylines
            print('Coords count: ${_currentRouteCoords.length}');
            print('Polylines count: ${_getPolylineCount(_currentRouteCoords)}');

            // Update map with new coordinates - this will clear old routes first
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

    return true;
  }

  void _stopRouteUpdates() {
    _routeUpdateTimer?.cancel();
    _routeUpdateTimer = null;
  }

  Future<void> _updateMapRoute() async {
    if (_mapViewId != null && _isMapReady) {
      try {
        // Always clear existing route first to prevent duplicates
        await _mapChannel.invokeMethod('clearRoute', {
          'viewId': _mapViewId,
        });

        // Print number of coordinates and polylines
        print('Coords count: ${_currentRouteCoords.length}');
        print('Polylines count: ${_getPolylineCount(_currentRouteCoords)}');

        // Then add the new route coordinates
        await _mapChannel.invokeMethod('updateRouteCoordinates', {
          'viewId': _mapViewId,
          'routeCoords': _currentRouteCoords,
        });
      } catch (e) {
        print('Error updating map route: $e');
      }
    }
  }

  // Helper to count polylines (if each segment is a polyline, it's coords.length-1, else 1)
  int _getPolylineCount(List<List<double>> coords) {
    // If you have multiple separate polylines, adjust this logic.
    // For a single continuous polyline, it's 1 if coords.length > 1, else 0.
    return coords.length > 1 ? 1 : 0;
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

      // Clear any existing map elements first
      await _mapChannel.invokeMethod('clearAllMapElements', {
        'viewId': viewId,
      });

      await _mapChannel.invokeMethod('initializeMap', {
        'viewId': viewId,
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

      // Print number of coordinates and polylines
      print('Coords count: ${_currentRouteCoords.length}');
      print('Polylines count: ${_getPolylineCount(_currentRouteCoords)}');

      await _fitRouteToScreen();
      setState(() {
        _isMapReady = true;
        _initialMapSetup = true; // Mark initial setup as complete
      });

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
      await _mapChannel
          .invokeMethod('fitRouteToScreen', {'viewId': _mapViewId});
    }
  }

  Future<void> _zoomMap(String direction) async {
    if (_mapViewId != null) {
      await _mapChannel.invokeMethod(
          direction == 'in' ? 'zoomIn' : 'zoomOut', {'viewId': _mapViewId});
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

          // Only update the map if it's already initialized but we haven't done the initial setup
          if (_isMapReady && _mapViewId != null && !_initialMapSetup) {
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
        // Initialize map only if not already initialized
        if (_mapViewId == null) {
          _initializeMap(id);
        }
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
